
// File: lib/modules/splash/widgets/futuristic_rings.dart
import 'package:aia/app/config/constants.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FuturisticRings extends StatelessWidget {
  final double rotationValue;
  final double scaleValue;
  
  const FuturisticRings({
    super.key,
    required this.rotationValue,
    required this.scaleValue,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleValue,
      child: Transform.rotate(
        angle: rotationValue,
        child: CustomPaint(
          size:  Size(AppConstants.ringWidth, AppConstants.ringHeight),
          painter: RingsPainter(),
        ),
      ),
    );
  }
}

class RingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Outer ring
    Paint outerRingPaint = Paint()
      ..color = Colors.transparent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF00A8FF),
          Color(0xFF00FFC2),
          Color(0xFF00A8FF),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius - 10, outerRingPaint);
    
    // Middle ring (dashed)
    Paint middleRingPaint = Paint()
      ..color = const Color(0xFF00D1FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    double dashLength = 15;
    double dashSpace = 8;
    double middleRadius = radius - 30;
    double startAngle = 0;
    
    for (double i = 0; i < 360; i += dashLength + dashSpace) {
      double startRadians = (startAngle + i) * (math.pi / 180);
      double endRadians = (startAngle + i + dashLength) * (math.pi / 180);
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: middleRadius),
        startRadians,
        (endRadians - startRadians),
        false,
        middleRingPaint,
      );
    }
    
    // Inner ring with dots
    Paint innerRingPaint = Paint()
      ..color = const Color(0xFF64E9FF).withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius - 55, innerRingPaint);
    
    // Dots on inner ring
    Paint dotPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 12; i++) {
      double angle = i * (math.pi / 6);
      double dotRadius = i % 3 == 0 ? 3.0 : 1.5;
      double dotX = center.dx + (radius - 55) * math.cos(angle);
      double dotY = center.dy + (radius - 55) * math.sin(angle);
      
      canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
