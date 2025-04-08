import 'package:get/get.dart';

class ChatModel {
  RxString streamingText;
  String text;
  final bool isUser;
  final DateTime timestamp;
  bool isTyping;
  RxBool isStreaming;
  bool isFirstMessage;
  RxBool isSpeaking = false.obs;
  RxBool isCopied = false.obs;

  ChatModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    RxBool? isStreaming,
    this.isFirstMessage = false,
    RxString? streamingText,
  })  : isStreaming = isStreaming ?? false.obs,
        streamingText = streamingText ?? RxString(text);

  ChatModel copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isTyping,
    RxBool? isStreaming,
    RxString? streamingText,
  }) {
    return ChatModel(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      isStreaming: isStreaming ?? this.isStreaming,
      streamingText: streamingText ?? this.streamingText,
    );
  }
}
