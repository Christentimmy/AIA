// lib/app/modules/chat/widgets/input_area.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/chat_controller.dart';

class ChatInputArea extends StatelessWidget {
  final ChatController controller;

  const ChatInputArea({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          // Text field in a glass container
          Expanded(
            child: _buildGlassTextField(),
          ),

          // Smart button (Mic / Loading / Send)
          _buildSmartButton(),
        ],
      ),
    );
  }

  Widget _buildGlassTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Attachment button as prefixIcon
              IconButton(
                icon: Icon(
                  Icons.attach_file,
                  color: Colors.white.withOpacity(0.6),
                ),
                onPressed: () {
                  // Handle attachment
                },
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: controller.messageController,
                  focusNode: controller.focusNode,
                  onChanged: (value) => controller.message.value = value,
                  style: GoogleFonts.rajdhani(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                  cursorColor: const Color(0xFF4FACFE),
                  maxLines: 3,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartButton() {
    return Obx(() {
      final isTextEmpty = controller.message.isEmpty;
      final isLoading = controller.isLoading.value;
      Icon icon;
      VoidCallback? onPressed;

      if (isLoading) {
        icon = const Icon(Icons.hourglass_bottom, color: Colors.white);
        onPressed = null;
      } else if (isTextEmpty && !controller.isListening.value) {
        icon = Icon(Icons.mic, color: Colors.white.withOpacity(0.8));
        onPressed = () async {
          await controller.listen();
        };
      } else if (isTextEmpty && controller.isListening.value) {
        icon = Icon(Icons.mic_off, color: Colors.white.withOpacity(0.8));
        onPressed = () {
          controller.stopListening();
        };
      } else if (isTextEmpty) {
        icon = const Icon(Icons.mic, color: Colors.white);
        onPressed = null;
      } else {
        icon = const Icon(Icons.send, color: Colors.white);
        onPressed = () {
          controller.sendMessage(controller.messageController.text);
        };
      }

      return Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          ),
          boxShadow: [
            if (isLoading)
              BoxShadow(
                color: const Color(0xFF4FACFE).withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
      );
    });
  }
}