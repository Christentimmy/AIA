import 'dart:convert';
import 'package:aia/app/config/api_key.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final client = http.Client();

  Stream<String> getAIResponseStream(String prompt) async* {
    final url = Uri.parse(openRouterApiUrl);
    final request = http.Request('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $openRouterApiKey',
      'Content-Type': 'application/json',
      'Accept': 'text/event-stream',
    });

    request.body = jsonEncode({
      "model": openRouterApiModel,
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "stream": true,
      "max_tokens": 200,
    });

    try {
      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode != 200) {
        yield "Failed to get response";
        return;
      }

      String buffer = "";

      await for (final chunk
          in streamedResponse.stream.transform(utf8.decoder)) {
        buffer += chunk;

        while (buffer.contains('\n')) {
          final lineEnd = buffer.indexOf('\n');
          final line = buffer.substring(0, lineEnd).trim();
          buffer = buffer.substring(lineEnd + 1);

          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') continue;

            try {
              final jsonData = jsonDecode(data);
              final content = jsonData['choices'][0]['delta']['content'];
              if (content != null) {
                yield content;
              }
            } catch (e) {
              print("Error parsing chunk: $e");
              // Skip invalid JSON rather than yielding an error
            }
          }
        }
      }
    } catch (e) {
      print("Stream error: $e");
      yield "Connection error. Please try again.";
    }
  }

  Future<String> getAIResponse(String prompt) async {
    final completeResponse = StringBuffer();
    await for (final chunk in getAIResponseStream(prompt)) {
      completeResponse.write(chunk);
    }
    return completeResponse.toString();
  }
}
