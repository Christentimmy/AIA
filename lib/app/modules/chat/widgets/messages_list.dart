import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../data/models/chat_model.dart';
import 'message_item.dart';
import 'typing_indicator.dart';

class MessagesListView extends StatelessWidget {
  final ChatController controller;

  const MessagesListView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        itemCount: controller.messages.length,
        reverse: false,
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          return _buildMessageItem(message, controller);
        },
      ),
    );
  }

  Widget _buildMessageItem(ChatModel message, ChatController controller) {
    if (message.isTyping) {
      return TypingIndicator(controller: controller);
    }

    return MessageItem(
      message: message,
      controller: controller,
      key: ValueKey(message.timestamp.toString()),
    );
  }
}
