class ChatModel {
  String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;
  final bool isStreaming;
  bool isFirstMessage;

  ChatModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
    this.isStreaming = false,
    this.isFirstMessage = false,
  });

  ChatModel copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isTyping,
    bool? isStreaming,
  }) {
    return ChatModel(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isTyping: isTyping ?? this.isTyping,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}
