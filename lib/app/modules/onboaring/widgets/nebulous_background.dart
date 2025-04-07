
import 'dart:math';
import 'package:flutter/material.dart';

// NEBULOUS BACKGROUND
class NebulousBackground extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;
  
  const NebulousBackground({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: NebulousBackgroundPainter(
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
        progress: progress,
      ),
    );
  }
}

class NebulousBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;
  
  NebulousBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    _paintNebulaEffect(canvas, size);
    _paintStarfield(canvas, size);
  }
  
  void _paintNebulaEffect(Canvas canvas, Size size) {
    final List<Offset> centers = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.15, size.height * 0.85),
      Offset(size.width * 0.9, size.height * 0.15),
    ];
    
    final List<double> radiusFactors = [0.5, 0.4, 0.6, 0.35, 0.45];
    
    for (int i = 0; i < centers.length; i++) {
      // Apply motion to the blobs - but ensure they stay within bounds
      final offset = Offset(
        50 * cos(progress * 2 * pi + i),
        30 * sin(progress * 2 * pi + i * 0.7),
      );
      
      final center = centers[i] + offset;
      final radius = radiusFactors[i] * size.width;
      
      // Ensure the center and radius create a valid rect
      final rect = Rect.fromCircle(
        center: center,
        radius: radius > 0 ? radius : 1.0, // Ensure radius is positive
      );
      
      // Make sure the rect is valid and within bounds
      if (rect.left.isFinite && rect.top.isFinite && 
          rect.right.isFinite && rect.bottom.isFinite &&
          rect.width > 0 && rect.height > 0) {
        
        final blob = Paint()
          ..shader = RadialGradient(
            colors: [
              (i % 2 == 0 ? primaryColor : secondaryColor).withOpacity(0.15),
              Colors.transparent,
            ],
            stops: const [0.2, 1.0],
          ).createShader(rect);
        
        canvas.drawCircle(
          center,
          radius,
          blob,
        );
      }
    }
  }
  
  void _paintStarfield(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent layout
    
    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      
      // Stars twinkle with the progress
      final twinkle = 0.3 + 0.7 * sin(progress * 2 * pi + i * 0.1);
      final starSize = (0.5 + random.nextDouble() * 1.5) * twinkle;
      
      // Only draw if the coordinates are valid
      if (x.isFinite && y.isFinite && starSize.isFinite && starSize > 0) {
        final starPaint = Paint()
          ..color = Colors.white.withOpacity(0.4 * twinkle)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          Offset(x, y),
          starSize,
          starPaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}