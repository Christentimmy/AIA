

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class QuantumNexusBackgroundPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  
  QuantumNexusBackgroundPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    _paintDimensionalRift(canvas, size);
    _paintQuantumParticles(canvas, size);
    _paintTimeflowLines(canvas, size);
    _paintHolographicInterface(canvas, size);
  }
  
  void _paintDimensionalRift(Canvas canvas, Size size) {
    // A subtle fractal-like dimensional tear in space-time
    final riftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    
    // Create gradient for the dimensional rift
    final riftGradient = ui.Gradient.linear(
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.7),
      [
        Color.lerp(primaryColor, Colors.black, 0.3)!.withOpacity(0.05),
        Color.lerp(secondaryColor, Colors.white, 0.2)!.withOpacity(0.08),
        Color.lerp(primaryColor, Colors.black, 0.1)!.withOpacity(0.05),
      ],
    );
    
    final fractals = 5;
    final seed = 42;
    final random = Random(seed);
    
    for (int f = 0; f < fractals; f++) {
      final centerX = size.width * (0.3 + 0.4 * random.nextDouble());
      final centerY = size.height * (0.3 + 0.4 * random.nextDouble());
      final radius = size.width * (0.15 + 0.1 * f / fractals);
      
      final branches = 3 + f;
      final path = Path();
      
      for (int b = 0; b < branches; b++) {
        final angle = 2 * pi * b / branches + progress * pi / 2;
        final startX = centerX;
        final startY = centerY;
        
        path.moveTo(startX, startY);
        
        // Create a fractal branch
        _drawFractalBranch(
          path, 
          startX, 
          startY, 
          angle, 
          radius * (0.7 + 0.3 * sin(progress * pi + f)), 
          0, 
          3, // Depth of recursion
          random,
          progress
        );
      }
      
      riftPaint.shader = riftGradient;
      canvas.drawPath(path, riftPaint);
    }
  }
  
  void _drawFractalBranch(
    Path path, 
    double x, 
    double y, 
    double angle, 
    double length, 
    int depth, 
    int maxDepth, 
    Random random,
    double progress
  ) {
    if (depth >= maxDepth) return;
    
    final endX = x + cos(angle) * length;
    final endY = y + sin(angle) * length;
    
    // Add some quantum uncertainty to the path
    final controlX = (x + endX) / 2 + sin(progress * pi + depth) * length * 0.2;
    final controlY = (y + endY) / 2 + cos(progress * pi - depth) * length * 0.2;
    
    path.quadraticBezierTo(controlX, controlY, endX, endY);
    
    // Create sub-branches
    final branchFactor = 0.65;
    final angleOffset = pi / 4 + random.nextDouble() * pi / 8;
    
    _drawFractalBranch(
      path, 
      endX, 
      endY, 
      angle + angleOffset * (1 + 0.2 * sin(progress * pi * 2)), 
      length * branchFactor, 
      depth + 1, 
      maxDepth, 
      random,
      progress
    );
    
    _drawFractalBranch(
      path, 
      endX, 
      endY, 
      angle - angleOffset * (1 + 0.2 * cos(progress * pi * 2)), 
      length * branchFactor, 
      depth + 1, 
      maxDepth, 
      random,
      progress
    );
  }
  
  void _paintQuantumParticles(Canvas canvas, Size size) {
    final random = Random(13);
    final particlePaint = Paint()
      ..style = PaintingStyle.fill;
    
    // Quantum particles exist in multiple states simultaneously
    for (int i = 0; i < 60; i++) {
      // Base position with some relation to screen divisions (quantum grid)
      final baseX = size.width * (i % 10) / 10 + random.nextDouble() * size.width * 0.1;
      final baseY = size.height * (i ~/ 10) / 6 + random.nextDouble() * size.height * 0.1;
      
      // Quantum state shifts position based on progress
      final quantumStateA = sin(progress * pi * 2 + i * 0.4) * 0.5 + 0.5;
      final quantumStateB = cos(progress * pi * 2 + i * 0.3) * 0.5 + 0.5;
      
      // Calculate multiple potential positions
      final positions = <Offset>[];
      for (int state = 0; state < 3; state++) {
        final stateProgress = (progress + state * 0.33) % 1.0;
        final xOffset = 20 * sin(stateProgress * pi * 2 + i * 0.7);
        final yOffset = 15 * cos(stateProgress * pi * 2 + i * 0.5);
        
        positions.add(Offset(
          (baseX + xOffset).clamp(0, size.width),
          (baseY + yOffset).clamp(0, size.height)
        ));
      }
      
      // Calculate probability of each state
      final probA = (0.3 + 0.7 * quantumStateA) * (1 - i % 3 * 0.2);
      final probB = (0.3 + 0.7 * quantumStateB) * (1 - (i + 1) % 3 * 0.2);
      final probC = 1 - (probA + probB).clamp(0.0, 0.9);
      
      // Draw quantum probability "cloud"
      if (i % 5 == 0) {
        final cloudPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = Color.lerp(primaryColor, secondaryColor, i / 60)!.withOpacity(0.02);
        
        // Create a small path between positions to represent quantum probability field
        final cloudPath = Path();
        cloudPath.moveTo(positions[0].dx, positions[0].dy);
        
        for (int p = 0; p < positions.length; p++) {
          final nextP = (p + 1) % positions.length;
          final controlPoint = Offset(
            (positions[p].dx + positions[nextP].dx) / 2 + sin(progress * pi + i) * 5,
            (positions[p].dy + positions[nextP].dy) / 2 + cos(progress * pi + i) * 5
          );
          
          cloudPath.quadraticBezierTo(
            controlPoint.dx, 
            controlPoint.dy,
            positions[nextP].dx, 
            positions[nextP].dy
          );
        }
        
        cloudPath.close();
        canvas.drawPath(cloudPath, cloudPaint);
      }
      
      // Draw particles at each position with varying opacity based on probability
      _drawParticle(canvas, positions[0], probA, i, 0);
      _drawParticle(canvas, positions[1], probB, i, 1);
      _drawParticle(canvas, positions[2], probC, i, 2);
    }
  }
  
  void _drawParticle(Canvas canvas, Offset position, double probability, int index, int state) {
    if (probability <= 0.05) return;
    
    final isBlue = index % 4 == state;
    final color = isBlue 
        ? primaryColor.withOpacity(0.08 * probability)
        : secondaryColor.withOpacity(0.08 * probability);
    
    final particlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    // Quantum particles are no longer just circles - they have ethereal shapes
    final particleSize = 2.0 + index % 3 * 0.5;
    
    if (index % 5 == 0) {
      // Diamond shape
      final path = Path();
      path.moveTo(position.dx, position.dy - particleSize);
      path.lineTo(position.dx + particleSize, position.dy);
      path.lineTo(position.dx, position.dy + particleSize);
      path.lineTo(position.dx - particleSize, position.dy);
      path.close();
      canvas.drawPath(path, particlePaint);
    } else if (index % 5 == 1) {
      // Triangle shape
      final path = Path();
      path.moveTo(position.dx, position.dy - particleSize);
      path.lineTo(position.dx + particleSize * 0.866, position.dy + particleSize * 0.5);
      path.lineTo(position.dx - particleSize * 0.866, position.dy + particleSize * 0.5);
      path.close();
      canvas.drawPath(path, particlePaint);
    } else {
      // Circle with halo
      canvas.drawCircle(position, particleSize, particlePaint);
      
      // Add quantum halo
      if (probability > 0.5 && index % 3 == 0) {
        final haloPaint = Paint()
          ..color = color.withOpacity(0.03)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5;
        
        canvas.drawCircle(position, particleSize * 2, haloPaint);
      }
    }
  }
  
  void _paintTimeflowLines(Canvas canvas, Size size) {
    // Time in 2799 is visible as flowing energy lines
    final flowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7
      ..strokeCap = StrokeCap.round;
    
    final timestreams = 7;
    final streamPoints = List.generate(timestreams, (i) => List<Offset>.empty(growable: true));
    
    // Generate points for time streams
    for (int stream = 0; stream < timestreams; stream++) {
      // Each timestream has a different flow pattern
      final streamPhase = stream / timestreams;
      final yBase = size.height * (0.2 + 0.6 * streamPhase);
      final points = <Offset>[];
      
      for (double t = 0; t <= 1.0; t += 0.01) {
        // Time isn't linear in 2799
        final warpedT = (t + progress + streamPhase) % 1.0;
        final x = size.width * t;
        
        // Complex time-space distortion equation
        final distortion = sin(warpedT * pi * 4 + stream) * cos(warpedT * pi * 2);
        final y = yBase + size.height * 0.05 * distortion;
        
        points.add(Offset(x, y));
      }
      
      streamPoints[stream] = points;
    }
    
    // Draw time streams
    for (int stream = 0; stream < timestreams; stream++) {
      final points = streamPoints[stream];
      if (points.isEmpty) continue;
      
      // Create time stream path
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      
      // Time streams change color as they flow
      final streamProgress = (progress + stream / timestreams) % 1.0;
      final streamColor = Color.lerp(
        primaryColor, 
        secondaryColor, 
        (sin(streamProgress * pi * 2) * 0.5 + 0.5)
      )!;
      
      flowPaint.color = streamColor.withOpacity(0.04);
      canvas.drawPath(path, flowPaint);
      
      // Draw time particles (chronons) along the stream
      if (stream % 2 == 0) {
        final particlePaint = Paint()
          ..color = streamColor.withOpacity(0.07)
          ..style = PaintingStyle.fill;
        
        final particleCount = 4 + stream % 3;
        for (int p = 0; p < particleCount; p++) {
          final particlePhase = (progress * 2 + p / particleCount + stream * 0.2) % 1.0;
          final index = (particlePhase * points.length).floor();
          
          if (index < points.length) {
            canvas.drawCircle(points[index], 1.2, particlePaint);
          }
        }
      }
    }
  }
  
  void _paintHolographicInterface(Canvas canvas, Size size) {
    // Holographic interfaces are subtle in 2799 - just transparent hints
    final holoPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;
    
    // Central data circle
    final centerX = size.width * 0.5;
    final centerY = size.height * 0.5;
    final mainRadius = size.width * 0.12;
    
    holoPaint.color = primaryColor.withOpacity(0.03);
    canvas.drawCircle(Offset(centerX, centerY), mainRadius, holoPaint);
    
    // Inner ring
    holoPaint.color = secondaryColor.withOpacity(0.02);
    canvas.drawCircle(Offset(centerX, centerY), mainRadius * 0.7, holoPaint);
    
    // Quantum scan bars
    for (int i = 0; i < 3; i++) {
      final scanProgress = (progress + i * 0.33) % 1.0;
      
      if (scanProgress < 0.7) {
        final scanHeight = size.height * 0.004;
        final scanY = centerY - mainRadius + scanProgress * mainRadius * 2;
        
        final scanPaint = Paint()
          ..shader = ui.Gradient.linear(
            Offset(centerX - mainRadius, scanY),
            Offset(centerX + mainRadius, scanY),
            [
              secondaryColor.withOpacity(0),
              primaryColor.withOpacity(0.05),
              secondaryColor.withOpacity(0),
            ]
          );
        
        canvas.drawRect(
          Rect.fromLTWH(
            centerX - mainRadius, 
            scanY - scanHeight / 2, 
            mainRadius * 2, 
            scanHeight
          ), 
          scanPaint
        );
      }
    }
    
    // Dynamic data points around the circle
    final dataPoints = 12;
    final dataPointPaint = Paint()
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < dataPoints; i++) {
      final angle = 2 * pi * i / dataPoints + progress * pi;
      final distance = mainRadius * (1 + 0.1 * sin(progress * pi * 4 + i));
      
      final x = centerX + cos(angle) * distance;
      final y = centerY + sin(angle) * distance;
      
      final pulseEffect = 0.5 + 0.5 * sin(progress * pi * 3 + i * 0.5);
      
      dataPointPaint.color = Color.lerp(
        primaryColor, 
        secondaryColor, 
        i / dataPoints
      )!.withOpacity(0.05 * pulseEffect);
      
      final pointSize = 1.0 + 0.5 * pulseEffect;
      canvas.drawCircle(Offset(x, y), pointSize, dataPointPaint);
      
      // Connection lines between data points
      if (i % 2 == 0) {
        final nextI = (i + 5) % dataPoints;
        final nextAngle = 2 * pi * nextI / dataPoints + progress * pi;
        final nextDistance = mainRadius * (1 + 0.1 * sin(progress * pi * 4 + nextI));
        
        final nextX = centerX + cos(nextAngle) * nextDistance;
        final nextY = centerY + sin(nextAngle) * nextDistance;
        
        holoPaint.color = dataPointPaint.color.withOpacity(0.02);
        canvas.drawLine(Offset(x, y), Offset(nextX, nextY), holoPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}