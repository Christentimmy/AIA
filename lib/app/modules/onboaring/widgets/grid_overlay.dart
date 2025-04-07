
// GRID OVERLAY WIDGET

import 'dart:math';
import 'package:flutter/material.dart';


class GridOverlay extends StatelessWidget {
  const GridOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: GridPainter(),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;
    
    // Perspective grid lines
    final vanishingPoint = Offset(size.width / 2, size.height * 0.4);
    
    // Horizontal lines
    for (double y = size.height * 0.4; y <= size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Radial lines from vanishing point
    for (int i = 0; i < 12; i++) {
      final angle = i * (pi / 6);
      final endX = vanishingPoint.dx + cos(angle) * size.width;
      final endY = vanishingPoint.dy + sin(angle) * size.height;
      canvas.drawLine(vanishingPoint, Offset(endX, endY), paint);
    }
    
    // Add subtle particles
    final particlePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final random = Random(42); // Fixed seed for consistent layout
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, particlePaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}