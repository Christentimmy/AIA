

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// HOLOGRAPHIC DISPLAY WIDGET
class HoloGraphicDisplay extends StatelessWidget {
  final IconData iconData;
  final Color primaryColor;
  final Color secondaryColor;
  final double animationValue;
  
  const HoloGraphicDisplay({
    super.key,
    required this.iconData,
    required this.primaryColor,
    required this.secondaryColor,
    required this.animationValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Holo base
          Transform.translate(
            offset: Offset(0, 10 * sin(animationValue * 2 * pi)),
            child: Container(
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.7),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          
          // Vertical light beam
          Positioned.fill(
            child: CustomPaint(
              painter: LightBeamPainter(
                baseColor: primaryColor,
                animationValue: animationValue,
              ),
            ),
          ),
          
          // Rotating hexagons
          Positioned.fill(
            child: _buildRotatingHexagons(),
          ),
          
          // Central icon with glow
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 60,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Glowing particles
          Positioned.fill(
            child: CustomPaint(
              painter: GlowingParticlesPainter(
                baseColor: secondaryColor,
                animationValue: animationValue,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRotatingHexagons() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer hexagon
        Transform.rotate(
          angle: -animationValue * 2 * pi,
          child: CustomPaint(
            size: const Size(180, 180),
            painter: HexagonPainter(
              color: primaryColor.withOpacity(0.4),
              thickness: 1,
            ),
          ),
        ),
        
        // Middle hexagon (rotating opposite direction)
        Transform.rotate(
          angle: animationValue * 2 * pi,
          child: CustomPaint(
            size: const Size(150, 150),
            painter: HexagonPainter(
              color: secondaryColor.withOpacity(0.3),
              thickness: 1,
            ),
          ),
        ),
        
        // Inner hexagon
        Transform.rotate(
          angle: -animationValue * pi,
          child: CustomPaint(
            size: const Size(120, 120),
            painter: HexagonPainter(
              color: primaryColor.withOpacity(0.2),
              thickness: 1,
            ),
          ),
        ),
      ],
    );
  }
}




// HEXAGON PAINTER
class HexagonPainter extends CustomPainter {
  final Color color;
  final double thickness;
  
  HexagonPainter({
    required this.color,
    required this.thickness,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * (pi / 180);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// LIGHT BEAM PAINTER
class LightBeamPainter extends CustomPainter {
  final Color baseColor;
  final double animationValue;
  
  LightBeamPainter({
    required this.baseColor,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Vertical light beam
    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          baseColor.withOpacity(0),
          baseColor.withOpacity(0.3 + 0.1 * sin(animationValue * 2 * pi)),
          baseColor.withOpacity(0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(
      Rect.fromLTWH(center.dx - 30, 0, 60, size.height),
      beamPaint,
    );
    
    // Horizontal scan line
    final scanY = size.height * (0.3 + 0.4 * sin(animationValue * 2 * pi));
    final scanPaint = Paint()
      ..color = baseColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawLine(
      Offset(center.dx - 60, scanY),
      Offset(center.dx + 60, scanY),
      scanPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// GLOWING PARTICLES PAINTER
class GlowingParticlesPainter extends CustomPainter {
  final Color baseColor;
  final double animationValue;
  final Random random = Random(42); // Fixed seed for consistent layout
  
  GlowingParticlesPainter({
    required this.baseColor,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    for (int i = 0; i < 20; i++) {
      final angle = 2 * pi * (i / 20);
      final radius = 70 + 20 * sin((animationValue * 2 * pi) + i);
      final x = center.dx + radius * cos(angle + animationValue * 2 * pi);
      final y = center.dy + radius * sin(angle + animationValue * 2 * pi);
      
      final particlePaint = Paint()
        ..color = baseColor.withOpacity(0.6 + 0.4 * random.nextDouble())
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(x, y),
        1 + random.nextDouble() * 2,
        particlePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}