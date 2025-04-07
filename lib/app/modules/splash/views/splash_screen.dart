import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class FuturisticSplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const FuturisticSplashScreen({
    Key? key,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  _FuturisticSplashScreenState createState() => _FuturisticSplashScreenState();
}

class _FuturisticSplashScreenState extends State<FuturisticSplashScreen>
    with TickerProviderStateMixin {
  // Controllers for different animation elements
  late AnimationController _textController;
  late AnimationController _particleController;
  late AnimationController _ringController;
  late AnimationController _glowController;
  late AnimationController _letterController;
  
  // Animations
  late Animation<double> _textScaleAnimation;
  late Animation<double> _ringRotationAnimation;
  late Animation<double> _ringScaleAnimation;
  late Animation<double> _glowAnimation;
  
  // Letter-specific animations
  late List<Animation<double>> _letterOffsetAnimations;
  late List<Animation<double>> _letterOpacityAnimations;
  
  // For particle effect
  final List<Particle> _particles = [];
  final int particleCount = 30;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize particles
    for (int i = 0; i < particleCount; i++) {
      _particles.add(Particle(random));
    }
    
    // Main text animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    
    _textScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));
    
    // Letter-by-letter animation
    _letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Create animations for each letter (A, I, A)
    _letterOffsetAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 50.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _letterController,
          curve: Interval(
            index * 0.2, // Stagger start times
            0.6 + index * 0.2, // Stagger end times
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
    
    _letterOpacityAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _letterController,
          curve: Interval(
            index * 0.2, // Stagger start times
            0.4 + index * 0.2, // Stagger end times
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
    
    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    // Ring animation
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _ringRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeInOutCubic,
    ));
    
    _ringScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 60,
      ),
    ]).animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOutCubic,
    ));
    
    // Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOutSine,
    ));
    
    // Start animations in sequence
    _ringController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _letterController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _particleController.forward();
      _textController.forward();
    });
    
    // Complete splash screen
    Future.delayed(const Duration(milliseconds: 3500), () {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _letterController.dispose();
    _particleController.dispose();
    _ringController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A18), // Deep space blue
      body: Stack(
        children: [
          // Background grid lines
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
          
          // Particle effect
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),
          
          // Text and rings in center
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating rings
                AnimatedBuilder(
                  animation: _ringController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _ringScaleAnimation.value,
                      child: Transform.rotate(
                        angle: _ringRotationAnimation.value,
                        child: CustomPaint(
                          size: const Size(280, 280),
                          painter: RingsPainter(),
                        ),
                      ),
                    );
                  },
                ),
                
                // Glow effect
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00A8FF).withOpacity(_glowAnimation.value * 0.3),
                            blurRadius: 30 * _glowAnimation.value,
                            spreadRadius: 5 * _glowAnimation.value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Animated AIA Text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _textScaleAnimation.value,
                      child: AnimatedBuilder(
                        animation: _letterController,
                        builder: (context, child) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // First "A"
                              _buildAnimatedLetter("A", 0),
                              
                              // "I"
                              _buildAnimatedLetter("I", 1),
                              
                              // Second "A"
                              _buildAnimatedLetter("A", 2),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Additional text at bottom if needed
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: AnimatedBuilder(
                animation: _letterController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _letterController.value,
                    child: Text(
                      "THE FUTURE OF CONVERSATION",
                      style: GoogleFonts.rajdhani(
                        textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimatedLetter(String letter, int index) {
    return AnimatedBuilder(
      animation: _letterController,
      builder: (context, child) {
        return Opacity(
          opacity: _letterOpacityAnimations[index].value,
          child: Transform.translate(
            offset: Offset(0, _letterOffsetAnimations[index].value),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: letter == "I" ? 6 : 8),
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF00E5FF),
                    const Color(0xFF29B6F6),
                  ],
                ).createShader(bounds),
                child: Text(
                  letter,
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom Painters (same as before)

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2138).withOpacity(0.5)
      ..strokeWidth = 1;
    
    // Horizontal lines
    double spacing = 30;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF00A8FF),
          const Color(0xFF00FFC2),
          const Color(0xFF00A8FF),
        ],
        stops: const [0.0, 0.5, 1.0],
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

class Particle {
  late double x;
  late double y;
  late double speed;
  late double size;
  late double opacity;
  late double direction;
  
  Particle(Random random) {
    reset(random, true);
  }
  
  void reset(Random random, bool initialSetup) {
    direction = random.nextDouble() * 2 * math.pi;
    speed = random.nextDouble() * 1.5 + 0.5;
    size = random.nextDouble() * 3 + 1;
    opacity = random.nextDouble() * 0.7 + 0.3;
    
    if (initialSetup) {
      x = random.nextDouble() * 400 - 200;
      y = random.nextDouble() * 400 - 200;
    } else {
      // Start from edges
      if (random.nextBool()) {
        x = random.nextBool() ? -200 : 200;
        y = random.nextDouble() * 400 - 200;
      } else {
        x = random.nextDouble() * 400 - 200;
        y = random.nextBool() ? -200 : 200;
      }
    }
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

// // Usage example
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: FuturisticSplashScreen(
//         onAnimationComplete: () {
//           // Navigate to your main app screen here
//         },
//       ),
//     );
//   }
// }