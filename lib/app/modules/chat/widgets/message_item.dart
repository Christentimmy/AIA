import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/chat_controller.dart';
import '../data/models/chat_model.dart';
import 'streaming_typer_text.dart';

class MessageItem extends StatelessWidget {
  final ChatModel message;
  final ChatController controller;

  const MessageItem({
    super.key,
    required this.message,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _buildMessageBubble(),
          const SizedBox(height: 6),
          _buildMessageActions(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildMessageBubble() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: message.isUser
            ? const Color(0xFF4FACFE)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        boxShadow: message.isUser
            ? [
                BoxShadow(
                  color: const Color(0xFF4FACFE).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Message text
            _buildMessageText(),
            const SizedBox(height: 4),
            // Timestamp
            _buildTimestamp(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageText() {
    final bool shouldStreamText =
        (!message.isUser && message.isStreaming.value == true) ||
            message.isFirstMessage;

    if (shouldStreamText) {
      return StreamingTypewriterText(
        streamingText: message.streamingText,
        messageModel: message,
        textStyle: GoogleFonts.rajdhani(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Text(
        message.text,
        style: GoogleFonts.rajdhani(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }
  }

  Widget _buildTimestamp() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        DateFormat('HH:mm').format(message.timestamp),
        style: TextStyle(
          color: message.isUser
              ? Colors.white.withOpacity(0.7)
              : Colors.white.withOpacity(0.5),
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMessageActions() {
    return Obx(() {
      if (!message.isStreaming.value && !message.isUser) {
        return Row(
          children: [
            // Speak button
            _buildActionButton(
              icon: message.isSpeaking.value
                  ? Icons.stop_circle
                  : Icons.volume_up_rounded,
              onTap: () async {
                if (message.isSpeaking.value) {
                  await controller.stopSpeaking(message);
                } else {
                  await controller.speak(message);
                }
              },
            ),
            const SizedBox(width: 10),

            // Copy button
            _buildActionButton(
              icon: message.isCopied.value
                  ? Icons.check_circle_outline
                  : Icons.copy_rounded,
              onTap: () async {
                await controller.copyToClipboard(message);
              },
            ),
          ],
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.grey.shade400,
        size: 17,
      ),
    );
  }
}
