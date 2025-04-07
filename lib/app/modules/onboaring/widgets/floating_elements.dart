import 'dart:math';
import 'package:flutter/material.dart';


// FLOATING ELEMENTS
class FloatingElements extends StatelessWidget {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;
  
  const FloatingElements({
    super.key,
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: FloatingElementsPainter(
        animationValue: animationValue,
        primaryColor: primaryColor,
        secondaryColor: secondaryColor,
      ),
    );
  }
}

class FloatingElementsPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;
  final Random random = Random(42); // Fixed seed for consistent layout
  
  FloatingElementsPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Add floating geometric elements
    _paintFloatingElements(canvas, size);
  }
  
  void _paintFloatingElements(Canvas canvas, Size size) {
    // Create different geometric shapes that float around the screen
    final List<Offset> positions = List.generate(15, (index) {
      return Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
    });
    
    final List<double> sizes = List.generate(15, (index) {
      return 8.0 + random.nextDouble() * 20.0;
    });
    
    for (int i = 0; i < positions.length; i++) {
      // Calculate movement
      final xOffset = 30 * cos(animationValue * 2 * pi + i * 0.7);
      final yOffset = 20 * sin(animationValue * 2 * pi + i * 0.5);
      final position = positions[i] + Offset(xOffset, yOffset);
      
      // Alternate between shapes and colors
      final color = i % 2 == 0
          ? primaryColor.withOpacity(0.2)
          : secondaryColor.withOpacity(0.2);
      
      final Paint elementPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      
      final shape = i % 3;
      final size = sizes[i];
      
      switch (shape) {
        case 0: // Circle
          canvas.drawCircle(position, size, elementPaint);
          break;
        case 1: // Square
          canvas.drawRect(
            Rect.fromCenter(center: position, width: size, height: size),
            elementPaint,
          );
          break;
        case 2: // Triangle
          final path = Path();
          path.moveTo(position.dx, position.dy - size / 2);
          path.lineTo(position.dx + size / 2, position.dy + size / 2);
          path.lineTo(position.dx - size / 2, position.dy + size / 2);
          path.close();
          canvas.drawPath(path, elementPaint);
          break;
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}