

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speech = SpeechToText();

  Future<bool> initialize({
    required void Function(String) onStatus,
    required void Function(SpeechRecognitionError) onError,
  }) async {
    return await _speech.initialize(
      onStatus: onStatus,
      onError: onError,
      debugLogging: true,
    );
  }

  void listen(void Function(String) onResult) {
    _speech.listen(
      onResult: (val) => onResult(val.recognizedWords),
      listenFor: const Duration(hours: 5),
      pauseFor: const Duration(hours: 2),
    );
  }

  void stop() => _speech.stop();
}
