import 'dart:math';
import 'package:flutter/material.dart';

class ChatBackgroundPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  
  ChatBackgroundPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Add subtle background patterns
    _paintSubtleGrid(canvas, size);
    _paintFloatingParticles(canvas, size);
  }
  
  void _paintSubtleGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    // Draw horizontal lines
    final spacing = size.height / 20;
    for (int i = 0; i < 20; i++) {
      final y = i * spacing;
      canvas.drawLine(
        Offset(0, y), 
        Offset(size.width, y), 
        paint,
      );
    }
    
    // Draw vertical lines
    final vSpacing = size.width / 12;
    for (int i = 0; i < 12; i++) {
      final x = i * vSpacing;
      canvas.drawLine(
        Offset(x, 0), 
        Offset(x, size.height), 
        paint,
      );
    }
  }
  
  void _paintFloatingParticles(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent layout
    
    for (int i = 0; i < 30; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      
      // Movement based on progress
      final xOffset = 20 * cos(progress * 2 * pi + i * 0.7);
      final yOffset = 15 * sin(progress * 2 * pi + i * 0.5);
      
      final x = baseX + xOffset;
      final y = baseY + yOffset;
      
      // Only draw if coordinates are valid
      if (x.isFinite && y.isFinite) {
        final particleSize = 1.0 + random.nextDouble() * 2.0;
        
        final isBlue = random.nextBool();
        final color = isBlue 
            ? primaryColor.withOpacity(0.1 + random.nextDouble() * 0.1)
            : secondaryColor.withOpacity(0.1 + random.nextDouble() * 0.1);
        
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          Offset(x, y),
          particleSize,
          paint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}