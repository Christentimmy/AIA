// File: lib/modules/splash/widgets/particle_system.dart
import 'package:aia/app/modules/splash/models/particle_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleSystem extends StatelessWidget {
  final double progress;
  final List<Particle> particles;
  
  const ParticleSystem({
    super.key,
    required this.progress,
    required this.particles,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: ParticlePainter(
        particles: particles,
        progress: progress,
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  
  ParticlePainter({required this.particles, required this.progress});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    for (var particle in particles) {
      // Calculate particle movement toward center as progress increases
      double moveX = particle.x + math.cos(particle.direction) * particle.speed * progress * 20;
      double moveY = particle.y + math.sin(particle.direction) * particle.speed * progress * 20;
      
      // As progress increases, particles move toward center with acceleration
      double centerFactor = progress * 2;
      double targetX = particle.x * (1 - centerFactor);
      double targetY = particle.y * (1 - centerFactor);
      
      double finalX = moveX * (1 - progress) + targetX * progress;
      double finalY = moveY * (1 - progress) + targetY * progress;
      
      // Draw particle
      Paint particlePaint = Paint()
        ..color = const Color(0xFF00E5FF).withOpacity(particle.opacity * (1 - progress * 0.5))
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(center.dx + finalX, center.dy + finalY),
        particle.size * (1 - progress * 0.5),
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}