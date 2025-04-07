
// DASHED RING WIDGET

import 'dart:math';
import 'package:flutter/material.dart';

class DashedRing extends StatelessWidget {
  final double radius;
  final Color color;
  final int dashCount;
  
  const DashedRing({
    super.key,
    required this.radius,
    required this.color,
    required this.dashCount,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius, radius),
      painter: DashedRingPainter(
        color: color,
        dashCount: dashCount,
      ),
    );
  }
}

class DashedRingPainter extends CustomPainter {
  final Color color;
  final int dashCount;
  
  DashedRingPainter({
    required this.color,
    required this.dashCount,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    final dashLength = 2 * pi / dashCount;
    final dashSpace = dashLength / 2;
    
    for (var i = 0.0; i < 2 * pi; i += dashLength + dashSpace) {
      canvas.drawArc(rect, i, dashLength, false, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}