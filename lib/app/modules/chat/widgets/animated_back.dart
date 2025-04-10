
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedChatBackground extends StatefulWidget {
  final BackgroundStyle style;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final double intensity;

  const AnimatedChatBackground({
    Key? key,
    this.style = BackgroundStyle.neuralNetwork,
    this.primaryColor = const Color(0xFF1A2151),
    this.secondaryColor = const Color(0xFF0D1137),
    this.accentColor = const Color(0xFF8A6FDF),
    this.intensity = 1.0,
  }) : super(key: key);

  @override
  _AnimatedChatBackgroundState createState() => _AnimatedChatBackgroundState();
}

enum BackgroundStyle {
  neuralNetwork,
  particles,
  gradientWave,
  dataStream,
  neonGrid
}

class _AnimatedChatBackgroundState extends State<AnimatedChatBackground>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _secondaryController;
  
  List<Particle> _particles = [];
  List<DataStream> _dataStreams = [];
  List<NeuralNode> _nodes = [];
  List<NeuralConnection> _connections = [];
  
  final int _particleCount = 50;
  final int _streamCount = 15;
  final int _nodeCount = 20;
  
  double _screenWidth = 0;
  double _screenHeight = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    // Secondary animation controller (different speed for certain effects)
    _secondaryController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    
    // Generate initial elements
    _initializeElements();
  }
  
  @override
  void dispose() {
    _mainController.dispose();
    _secondaryController.dispose();
    super.dispose();
  }
  
  void _initializeElements() {
    final random = math.Random();
    
    // Initialize particles
    _particles = List.generate(_particleCount, (index) {
      return Particle(
        position: Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 2000,
        ),
        speed: 0.5 + random.nextDouble() * 1.5,
        radius: 1 + random.nextDouble() * 3,
        alpha: 0.1 + random.nextDouble() * 0.4,
      );
    });
    
    // Initialize data streams
    _dataStreams = List.generate(_streamCount, (index) {
      return DataStream(
        startPosition: Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 2000,
        ),
        length: 50 + random.nextDouble() * 150,
        speed: 40 + random.nextDouble() * 100,
        thickness: 1 + random.nextDouble() * 2,
        alpha: 0.05 + random.nextDouble() * 0.2,
      );
    });
    
    // Initialize neural network nodes
    _nodes = List.generate(_nodeCount, (index) {
      return NeuralNode(
        position: Offset(
          random.nextDouble() * 1000,
          random.nextDouble() * 2000,
        ),
        radius: 3 + random.nextDouble() * 5,
        pulseSpeed: 0.5 + random.nextDouble() * 1.5,
        phaseOffset: random.nextDouble() * math.pi * 2,
      );
    });
    
    // Create neural connections
    _connections = [];
    for (int i = 0; i < _nodes.length; i++) {
      for (int j = i + 1; j < _nodes.length; j++) {
        if (random.nextDouble() < 0.2) {  // 20% chance to create a connection
          _connections.add(NeuralConnection(
            nodeA: i,
            nodeB: j,
            pulseSpeed: 0.5 + random.nextDouble(),
            phaseOffset: random.nextDouble() * math.pi * 2,
          ));
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenWidth = constraints.maxWidth;
        _screenHeight = constraints.maxHeight;
        
        return Container(
          width: _screenWidth,
          height: _screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [widget.primaryColor, widget.secondaryColor],
              stops: const [0.0, 1.0],
            ),
          ),
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(_screenWidth, _screenHeight),
                painter: _getBackgroundPainter(),
              );
            },
          ),
        );
      },
    );
  }
  
  CustomPainter _getBackgroundPainter() {
    switch (widget.style) {
      case BackgroundStyle.neuralNetwork:
        return NeuralNetworkPainter(
          nodes: _nodes,
          connections: _connections,
          animationValue: _mainController.value,
          accentColor: widget.accentColor,
          intensity: widget.intensity,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        );
      case BackgroundStyle.particles:
        return ParticlePainter(
          particles: _particles,
          animationValue: _mainController.value,
          accentColor: widget.accentColor,
          intensity: widget.intensity,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        );
      case BackgroundStyle.gradientWave:
        return GradientWavePainter(
          animationValue: _secondaryController.value,
          accentColor: widget.accentColor,
          intensity: widget.intensity,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        );
      case BackgroundStyle.dataStream:
        return DataStreamPainter(
          dataStreams: _dataStreams,
          animationValue: _mainController.value,
          accentColor: widget.accentColor,
          intensity: widget.intensity,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        );
      case BackgroundStyle.neonGrid:
        return NeonGridPainter(
          animationValue: _mainController.value,
          accentColor: widget.accentColor,
          intensity: widget.intensity,
          screenWidth: _screenWidth,
          screenHeight: _screenHeight,
        );
    }
  }
}

// ========== NEURAL NETWORK ELEMENTS ==========

class NeuralNode {
  Offset position;
  final double radius;
  final double pulseSpeed;
  final double phaseOffset;
  
  NeuralNode({
    required this.position,
    required this.radius,
    required this.pulseSpeed,
    required this.phaseOffset,
  });
  
  double getPulseRadius(double animationValue) {
    return radius * (0.8 + 0.4 * math.sin((animationValue * pulseSpeed * math.pi * 2) + phaseOffset));
  }
  
  double getPulseOpacity(double animationValue) {
    return 0.4 + 0.6 * math.sin((animationValue * pulseSpeed * math.pi) + phaseOffset).abs();
  }
}

class NeuralConnection {
  final int nodeA;
  final int nodeB;
  final double pulseSpeed;
  final double phaseOffset;
  
  NeuralConnection({
    required this.nodeA,
    required this.nodeB,
    required this.pulseSpeed,
    required this.phaseOffset,
  });
  
  double getPulseOpacity(double animationValue) {
    return 0.05 + 0.2 * math.sin((animationValue * pulseSpeed * math.pi * 2) + phaseOffset).abs();
  }
  
  double getPulseIntensity(double animationValue) {
    return math.sin((animationValue * pulseSpeed * math.pi * 2) + phaseOffset).abs();
  }
}

class NeuralNetworkPainter extends CustomPainter {
  final List<NeuralNode> nodes;
  final List<NeuralConnection> connections;
  final double animationValue;
  final Color accentColor;
  final double intensity;
  final double screenWidth;
  final double screenHeight;
  
  NeuralNetworkPainter({
    required this.nodes,
    required this.connections,
    required this.animationValue,
    required this.accentColor,
    required this.intensity,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final maxDistance = screenWidth * 0.3;
    
    // Apply screen transform to make it responsive and dynamic
    for (var node in nodes) {
      node.position = Offset(
        (node.position.dx + animationValue * 10) % screenWidth,
        (node.position.dy + animationValue * 5) % screenHeight,
      );
    }
    
    // Draw connections
    for (var connection in connections) {
      final nodeA = nodes[connection.nodeA];
      final nodeB = nodes[connection.nodeB];
      
      final distance = (nodeA.position - nodeB.position).distance;
      if (distance < maxDistance) {
        final opacity = connection.getPulseOpacity(animationValue) * (1 - distance / maxDistance) * intensity;
        
        final paint = Paint()
          ..color = accentColor.withOpacity(opacity)
          ..strokeWidth = 1 * intensity
          ..style = PaintingStyle.stroke;
        
        canvas.drawLine(nodeA.position, nodeB.position, paint);
        
        // Draw pulse traveling along the connection
        final pulseIntensity = connection.getPulseIntensity(animationValue);
        final pulsePosition = Offset.lerp(
          nodeA.position,
          nodeB.position,
          (animationValue + connection.phaseOffset) % 1.0,
        )!;
        
        final pulsePaint = Paint()
          ..color = accentColor.withOpacity(0.8 * pulseIntensity * intensity)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(pulsePosition, 2 * intensity, pulsePaint);
      }
    }
    
    // Draw nodes
    for (var node in nodes) {
      final pulseRadius = node.getPulseRadius(animationValue);
      final pulseOpacity = node.getPulseOpacity(animationValue);
      
      // Draw glow
      final glowPaint = Paint()
        ..color = accentColor.withOpacity(0.2 * pulseOpacity * intensity)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * intensity);
      
      canvas.drawCircle(node.position, pulseRadius * 2, glowPaint);
      
      // Draw node
      final nodePaint = Paint()
        ..color = accentColor.withOpacity(pulseOpacity * intensity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(node.position, pulseRadius, nodePaint);
      
      // Draw node core
      final corePaint = Paint()
        ..color = Colors.white.withOpacity(pulseOpacity * intensity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(node.position, pulseRadius * 0.4, corePaint);
    }
  }
  
  @override
  bool shouldRepaint(NeuralNetworkPainter oldDelegate) => true;
}

// ========== PARTICLE ELEMENTS ==========

class Particle {
  Offset position;
  final double speed;
  final double radius;
  final double alpha;
  
  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.alpha,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final Color accentColor;
  final double intensity;
  final double screenWidth;
  final double screenHeight;
  
  ParticlePainter({
    required this.particles,
    required this.animationValue,
    required this.accentColor,
    required this.intensity,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final maxDistance = screenWidth * 0.2;
    
    // Update particle positions
    for (var particle in particles) {
      particle.position = Offset(
        (particle.position.dx + particle.speed) % screenWidth,
        (particle.position.dy + particle.speed * 0.5) % screenHeight,
      );
    }
    
    // Draw connections between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = (particles[i].position - particles[j].position).distance;
        
        if (distance < maxDistance) {
          final opacity = (1 - distance / maxDistance) * 0.2 * intensity;
          
          final paint = Paint()
            ..color = accentColor.withOpacity(opacity)
            ..strokeWidth = 1 * intensity
            ..style = PaintingStyle.stroke;
          
          canvas.drawLine(particles[i].position, particles[j].position, paint);
        }
      }
    }
    
    // Draw particles
    for (var particle in particles) {
      final paint = Paint()
        ..color = accentColor.withOpacity(particle.alpha * intensity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(particle.position, particle.radius * intensity, paint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// ========== GRADIENT WAVE ELEMENTS ==========

class GradientWavePainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;
  final double intensity;
  final double screenWidth;
  final double screenHeight;
  
  GradientWavePainter({
    required this.animationValue,
    required this.accentColor,
    required this.intensity,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          accentColor.withOpacity(0.2 * intensity),
          accentColor.withOpacity(0.05 * intensity),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, screenWidth, screenHeight));
    
    final waveCount = 3;
    
    for (int i = 0; i < waveCount; i++) {
      final path = Path();
      final amplitude = screenHeight * 0.05 * (i + 1) * intensity;
      final frequency = 0.02 * (i + 1);
      final phaseOffset = (animationValue + i * 0.3) * math.pi * 2;
      
      path.moveTo(0, screenHeight * 0.5);
      
      for (double x = 0; x <= screenWidth; x += 5) {
        final y = screenHeight * 0.5 + 
                  math.sin((x * frequency) + phaseOffset) * amplitude;
        path.lineTo(x, y);
      }
      
      path.lineTo(screenWidth, screenHeight);
      path.lineTo(0, screenHeight);
      path.close();
      
      canvas.drawPath(path, wavePaint);
    }
    
    // Draw some floating dots on top of the waves
    final dotCount = 50;
    final random = math.Random(42);  // Fixed seed for consistent randomness
    
    for (int i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * screenWidth;
      final baseY = screenHeight * 0.5;
      final phase = (animationValue + random.nextDouble()) * math.pi * 2;
      final amplitude = screenHeight * 0.05 * intensity;
      
      final y = baseY + math.sin(phase) * amplitude;
      final radius = 1 + random.nextDouble() * 2 * intensity;
      final alpha = 0.1 + random.nextDouble() * 0.3;
      
      final paint = Paint()
        ..color = accentColor.withOpacity(alpha * intensity)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(GradientWavePainter oldDelegate) => true;
}

// ========== DATA STREAM ELEMENTS ==========

class DataStream {
  Offset startPosition;
  final double length;
  final double speed;
  final double thickness;
  final double alpha;
  
  DataStream({
    required this.startPosition,
    required this.length,
    required this.speed,
    required this.thickness,
    required this.alpha,
  });
}

class DataStreamPainter extends CustomPainter {
  final List<DataStream> dataStreams;
  final double animationValue;
  final Color accentColor;
  final double intensity;
  final double screenWidth;
  final double screenHeight;
  
  DataStreamPainter({
    required this.dataStreams,
    required this.animationValue,
    required this.accentColor,
    required this.intensity,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);  // Fixed seed for consistent randomness
    
    // Update stream positions
    for (var stream in dataStreams) {
      stream.startPosition = Offset(
        stream.startPosition.dx,
        (stream.startPosition.dy + stream.speed * animationValue) % (screenHeight + stream.length),
      );
    }
    
    // Draw data streams
    for (var stream in dataStreams) {
      final streamPaint = Paint()
        ..color = accentColor.withOpacity(stream.alpha * intensity)
        ..strokeWidth = stream.thickness * intensity
        ..style = PaintingStyle.stroke;
      
      final path = Path();
      path.moveTo(stream.startPosition.dx, stream.startPosition.dy);
      
      double currentY = stream.startPosition.dy;
      final endY = currentY + stream.length;
      
      while (currentY < endY) {
        // Create segments of varying lengths
        final segmentLength = 2 + random.nextDouble() * 8;
        final nextY = currentY + segmentLength;
        
        if (nextY < endY) {
          path.lineTo(stream.startPosition.dx, nextY);
          
          // Occasionally add a gap
          if (random.nextDouble() < 0.3) {
            currentY = nextY + 2 + random.nextDouble() * 5;
            if (currentY < endY) {
              path.moveTo(stream.startPosition.dx, currentY);
            }
          } else {
            currentY = nextY;
          }
        } else {
          path.lineTo(stream.startPosition.dx, endY);
          break;
        }
      }
      
      canvas.drawPath(path, streamPaint);
      
      // Add some data "packets" along the stream
      final packetCount = (stream.length / 20).round();
      for (int i = 0; i < packetCount; i++) {
        if (random.nextDouble() < 0.5) {  // 50% chance for a packet at each position
          final packetY = stream.startPosition.dy + i * 20 + 
                          (animationValue * 100) % 20;
          
          if (packetY < stream.startPosition.dy + stream.length && 
              packetY >= stream.startPosition.dy) {
            final packetPaint = Paint()
              ..color = Colors.white.withOpacity(0.6 * stream.alpha * intensity)
              ..style = PaintingStyle.fill;
            
            canvas.drawCircle(
              Offset(stream.startPosition.dx, packetY),
              2 * intensity,
              packetPaint,
            );
          }
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(DataStreamPainter oldDelegate) => true;
}

// ========== NEON GRID ELEMENTS ==========

class NeonGridPainter extends CustomPainter {
  final double animationValue;
  final Color accentColor;
  final double intensity;
  final double screenWidth;
  final double screenHeight;
  
  NeonGridPainter({
    required this.animationValue,
    required this.accentColor,
    required this.intensity,
    required this.screenWidth,
    required this.screenHeight,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final perspective = 800.0;
    final gridSpacing = 50.0;
    final gridSizeX = (screenWidth / gridSpacing).ceil() + 2;
    final gridSizeY = (screenHeight / gridSpacing).ceil() + 5;
    
    // Calculate grid origin with animation
    final originX = screenWidth / 2;
    final originY = screenHeight + 200 - (animationValue * gridSpacing * 2) % gridSpacing;
    
    // Draw horizontal grid lines
    for (int y = 0; y < gridSizeY; y++) {
      final gridY = originY - y * gridSpacing;
      final z = (perspective - (originY - gridY)) / perspective;
      
      if (z <= 0) continue;
      
      final alpha = (z * 0.5) * intensity;
      final thickness = z * 2 * intensity;
      
      final paint = Paint()
        ..color = accentColor.withOpacity(alpha)
        ..strokeWidth = thickness
        ..style = PaintingStyle.stroke;
      
      // Calculate perspective endpoints
      final startX = originX - (screenWidth * z) / 2;
      final endX = originX + (screenWidth * z) / 2;
      
      canvas.drawLine(
        Offset(startX, gridY),
        Offset(endX, gridY),
        paint,
      );
    }
    
    // Draw vertical grid lines
    for (int x = -gridSizeX; x <= gridSizeX; x++) {
      final baseGridX = originX + x * gridSpacing;
      
      // Create path for the vertical line with perspective
      final path = Path();
      path.moveTo(baseGridX, originY);
      
      for (int y = 1; y < gridSizeY; y++) {
        final gridY = originY - y * gridSpacing;
        final z = (perspective - (originY - gridY)) / perspective;
        
        if (z <= 0) continue;
        
        final gridX = originX + (baseGridX - originX) * z;
        path.lineTo(gridX, gridY);
      }
      
      // Draw the vertical line with glow effect
      final paint = Paint()
        ..color = accentColor.withOpacity(0.3 * intensity)
        ..strokeWidth = 1.5 * intensity
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, 2 * intensity);
      
      canvas.drawPath(path, paint);
      
      // Draw the vertical line
      final linePaint = Paint()
        ..color = accentColor.withOpacity(0.5 * intensity)
        ..strokeWidth = 1 * intensity
        ..style = PaintingStyle.stroke;
      
      canvas.drawPath(path, linePaint);
    }
    
    // Add some floating particles for extra effect
    final particleCount = 30;
    final random = math.Random(42);  // Fixed seed for consistent randomness
    
    for (int i = 0; i < particleCount; i++) {
      final baseX = (random.nextDouble() - 0.5) * screenWidth;
      final baseY = random.nextDouble() * screenHeight;
      
      // Create a swirling motion
      final angle = (animationValue * 2 + i * 0.1) * math.pi * 2;
      final radius = 20 + random.nextDouble() * 40;
      
      final x = originX + baseX + math.cos(angle) * radius;
      final y = baseY - animationValue * (100 + random.nextDouble() * 200);
      final adjustedY = y % screenHeight;
      
      // Calculate perspective z based on y position
      final z = (perspective - (originY - adjustedY)) / perspective;
      
      if (z <= 0) continue;
      
      final alpha = z * 0.5 * intensity;
      final particleSize = 1 + random.nextDouble() * 3 * z * intensity;
      
      final paint = Paint()
        ..color = accentColor.withOpacity(alpha)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, adjustedY), particleSize, paint);
    }
  }
  
  @override
  bool shouldRepaint(NeonGridPainter oldDelegate) => true;
}