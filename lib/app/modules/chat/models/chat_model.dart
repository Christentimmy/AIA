
class ChatModel {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  ChatModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });
}
