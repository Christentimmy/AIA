
// lib/app/modules/chat/widgets/typing_indicator.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class TypingIndicator extends StatelessWidget {
  final ChatController controller;

  const TypingIndicator({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Obx(() {
        final animValue = controller.animationValue.value;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final delay = index * 0.2;
              final offset = (animValue + delay) % 1.0;
              final size = 4 + 4 * sin(offset * pi);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF4FACFE)
                      .withOpacity(0.6 + 0.4 * sin(offset * pi)),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}