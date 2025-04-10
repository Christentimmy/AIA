
// lib/app/modules/chat/widgets/background_effects.dart
import 'package:flutter/material.dart';
import '../widgets/chat_background.dart';

class BackgroundEffects extends StatelessWidget {
  final double animValue;

  const BackgroundEffects({
    super.key,
    required this.animValue,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        size: Size.infinite,
        painter: ChatBackgroundPainter(
          progress: animValue,
          primaryColor: const Color(0xFF4FACFE),
          secondaryColor: const Color(0xFF00F2FE),
        ),
      ),
    );
  }
}