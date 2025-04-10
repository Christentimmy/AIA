


import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class BeyondRealityChatBackground extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  
  // Extended color palette
  late final List<Color> neuralColors = [
    const Color(0xFFE44C65),  // Crimson energy
    const Color(0xFF19FFCD),  // Neural teal
    const Color(0xFFA155FE),  // Quantum violet
    const Color(0xFFFF9D41),  // Synthetic amber
    const Color(0xFF54FFEA),  // Digital azure
    primaryColor,            // Original primary
    secondaryColor,          // Original secondary
  ];
  
  BeyondRealityChatBackground({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Neural substrate layer
    _paintNeuralSubstrate(canvas, size);
    
    // Thought bridges
    _paintThoughtBridges(canvas, size);
    
    // Consciousness nodes
    _paintConsciousnessNodes(canvas, size);
    
    // Sentience particles
    _paintSentienceParticles(canvas, size);
    
    // Energy flow
    _paintEnergyFlow(canvas, size);
  }
  
  void _paintNeuralSubstrate(Canvas canvas, Size size) {
    // Neural substrate with variable density and energy states
    final random = Random(42);
    const neuralDensity = 20; // Number of neural pathways
    
    for (int i = 0; i < neuralDensity; i++) {
      final pathOpacity = 0.02 + 0.015 * random.nextDouble();
      final pathWidth = 0.3 + 0.6 * random.nextDouble();
      
      final pathPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = pathWidth
        ..strokeCap = StrokeCap.round;
        
      // Neural pathway path
      final path = Path();
      
      // Each pathway has a different starting point and behavior
      final startX = -20 + random.nextDouble() * (size.width + 40);
      final startY = -20 + random.nextDouble() * (size.height + 40);
      
      path.moveTo(startX, startY);
      
      // Create organic neural pathway with multiple curves
      double currentX = startX;
      double currentY = startY;
      final pointCount = 3 + random.nextInt(5);
      
      final colorIndex1 = random.nextInt(neuralColors.length);
      final colorIndex2 = (colorIndex1 + 1 + random.nextInt(neuralColors.length - 1)) % neuralColors.length;
      
      pathPaint.shader = ui.Gradient.linear(
        Offset(currentX, currentY),
        Offset(currentX + size.width * 0.3, currentY + size.height * 0.3),
        [
          neuralColors[colorIndex1].withOpacity(pathOpacity),
          neuralColors[colorIndex2].withOpacity(pathOpacity * 1.2),
          neuralColors[colorIndex1].withOpacity(pathOpacity * 0.8),
        ],
      );
      
      for (int p = 0; p < pointCount; p++) {
        // Neural pathways bend in flowing patterns
        final phase = progress * 2 * pi + i * 0.2 + p * 0.3;
        final nextX = currentX + size.width * (0.1 + 0.15 * random.nextDouble()) * 
                      (random.nextBool() ? 1 : -1) * 
                      (1 + 0.2 * sin(phase));
        final nextY = currentY + size.height * (0.1 + 0.15 * random.nextDouble()) * 
                      (random.nextBool() ? 1 : -1) *
                      (1 + 0.2 * cos(phase));
        
        final ctrlX1 = currentX + (nextX - currentX) * (0.3 + 0.2 * random.nextDouble());
        final ctrlY1 = currentY + (nextY - currentY) * (0.3 + 0.2 * random.nextDouble());
        final ctrlX2 = currentX + (nextX - currentX) * (0.6 + 0.2 * random.nextDouble());
        final ctrlY2 = currentY + (nextY - currentY) * (0.6 + 0.2 * random.nextDouble());
        
        path.cubicTo(ctrlX1, ctrlY1, ctrlX2, ctrlY2, nextX, nextY);
        
        currentX = nextX;
        currentY = nextY;
      }
      
      canvas.drawPath(path, pathPaint);
    }
  }
  
  void _paintThoughtBridges(Canvas canvas, Size size) {
    // Abstract thought bridges connecting concepts
    const bridgeCount = 12;
    final random = Random(24);
    
    for (int i = 0; i < bridgeCount; i++) {
      final startRegion = i % 4; // 4 conceptual regions
      final endRegion = (startRegion + 1 + random.nextInt(2)) % 4;
      
      // Region coordinates
      final regions = [
        Rect.fromLTWH(0, 0, size.width * 0.4, size.height * 0.4),
        Rect.fromLTWH(size.width * 0.6, 0, size.width * 0.4, size.height * 0.4),
        Rect.fromLTWH(0, size.height * 0.6, size.width * 0.4, size.height * 0.4),
        Rect.fromLTWH(size.width * 0.6, size.height * 0.6, size.width * 0.4, size.height * 0.4),
      ];
      
      final startRect = regions[startRegion];
      final endRect = regions[endRegion];
      
      final startX = startRect.left + startRect.width * random.nextDouble();
      final startY = startRect.top + startRect.height * random.nextDouble();
      final endX = endRect.left + endRect.width * random.nextDouble();
      final endY = endRect.top + endRect.height * random.nextDouble();
      
      // Thought stream with pulsing effect
      final thoughtPhase = (progress * 0.5 + i * 0.08) % 1.0;
      final thoughtOpacity = 0.04 * (0.5 + 0.5 * sin(thoughtPhase * 2 * pi));
      
      final thoughtPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..strokeCap = StrokeCap.round;
      
      final colorA = neuralColors[i % neuralColors.length];
      final colorB = neuralColors[(i + 2) % neuralColors.length];
      
      thoughtPaint.shader = ui.Gradient.linear(
        Offset(startX, startY),
        Offset(endX, endY),
        [
          colorA.withOpacity(thoughtOpacity),
          colorB.withOpacity(thoughtOpacity * 1.2),
          colorA.withOpacity(thoughtOpacity * 0.7),
        ],
      );
      
      final path = Path();
      path.moveTo(startX, startY);
      
      // Control points for bezier curve with some randomness
      final controlX1 = startX + (endX - startX) * (0.3 + 0.2 * sin(progress * pi + i));
      final controlY1 = startY + (endY - startY) * (0.1 + 0.1 * cos(progress * pi + i * 0.7));
      final controlX2 = startX + (endX - startX) * (0.7 + 0.2 * sin(progress * pi + i * 0.5));
      final controlY2 = startY + (endY - startY) * (0.9 + 0.1 * cos(progress * pi + i * 0.3));
      
      path.cubicTo(controlX1, controlY1, controlX2, controlY2, endX, endY);
      
      canvas.drawPath(path, thoughtPaint);
      
      // Thought particles flowing along the path
      if (i % 2 == 0) {
        final particleCount = 3 + random.nextInt(2);
        
        for (int p = 0; p < particleCount; p++) {
          final particlePhase = (progress + p * 0.3 + i * 0.05) % 1.0;
          
          // Calculate position along the curve
          final t = particlePhase;
          final mt = 1 - t;
          
          final px = mt * mt * mt * startX + 
                   3 * mt * mt * t * controlX1 +
                   3 * mt * t * t * controlX2 +
                   t * t * t * endX;
                   
          final py = mt * mt * mt * startY + 
                   3 * mt * mt * t * controlY1 +
                   3 * mt * t * t * controlY2 +
                   t * t * t * endY;
          
          // Draw thought particle
          final particlePaint = Paint()
            ..color = colorB.withOpacity(0.08 + 0.05 * sin(progress * pi * 2 + p))
            ..style = PaintingStyle.fill;
            
          canvas.drawCircle(Offset(px, py), 1.4, particlePaint);
        }
      }
    }
  }
  
  void _paintConsciousnessNodes(Canvas canvas, Size size) {
    // Consciousness nodes - centers of digital cognition
    final random = Random(33);
    const nodeCount = 5;
    
    for (int i = 0; i < nodeCount; i++) {
      // Node position with slight drift
      final baseX = size.width * (0.2 + 0.6 * (i / (nodeCount - 1)));
      final baseY = size.height * (0.3 + 0.4 * random.nextDouble());
      
      final xDrift = size.width * 0.03 * sin(progress * pi * 2 + i * 0.7);
      final yDrift = size.height * 0.02 * cos(progress * pi * 2 + i * 0.5);
      
      final x = baseX + xDrift;
      final y = baseY + yDrift;
      
      final nodeSize = size.width * (0.03 + 0.01 * random.nextDouble());
      
      // Core node appearance
      final nodePaint = Paint()
        ..style = PaintingStyle.fill;
      
      // Color cycling based on neural activity
      final colorCycle = (progress * 0.3 + i * 0.2) % 1.0;
      final colorIndex = (i + (colorCycle * neuralColors.length).floor()) % neuralColors.length;
      final nodeColor = neuralColors[colorIndex];
      
      // Neural activity pattern
      final activityLevel = 0.5 + 0.5 * sin(progress * pi * 3 + i * 0.8);
      
      // Node core
      nodePaint.color = nodeColor.withOpacity(0.03 + 0.02 * activityLevel);
      canvas.drawCircle(Offset(x, y), nodeSize * 0.7, nodePaint);
      
      // Node outer ring
      final ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5
        ..color = nodeColor.withOpacity(0.03);
        
      canvas.drawCircle(Offset(x, y), nodeSize, ringPaint);
      
      // Consciousness field around the node
      final consciousnessRadius = nodeSize * (1.5 + 0.5 * activityLevel);
      final fieldPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3;
        
      // Multiple consciousness layers
      for (int layer = 0; layer < 3; layer++) {
        final layerRadius = consciousnessRadius * (1 + layer * 0.5);
        final layerOpacity = 0.01 * (3 - layer) * activityLevel;
        
        fieldPaint.color = nodeColor.withOpacity(layerOpacity);
        canvas.drawCircle(Offset(x, y), layerRadius, fieldPaint);
      }
      
      // Neural connections between adjacent nodes
      if (i < nodeCount - 1) {
        final nextI = i + 1;
        final nextBaseX = size.width * (0.2 + 0.6 * (nextI / (nodeCount - 1)));
        final nextBaseY = size.height * (0.3 + 0.4 * random.nextDouble());
        
        final nextXDrift = size.width * 0.03 * sin(progress * pi * 2 + nextI * 0.7);
        final nextYDrift = size.height * 0.02 * cos(progress * pi * 2 + nextI * 0.5);
        
        final nextX = nextBaseX + nextXDrift;
        final nextY = nextBaseY + nextYDrift;
        
        // Connection line with energy pulses
        final connectionPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.4
          ..color = nodeColor.withOpacity(0.02);
          
        canvas.drawLine(Offset(x, y), Offset(nextX, nextY), connectionPaint);
        
        // Energy pulses along the connection
        const pulseCount = 2;
        for (int p = 0; p < pulseCount; p++) {
          final pulsePhase = (progress + p * 0.5) % 1.0;
          
          final pulseX = x + (nextX - x) * pulsePhase;
          final pulseY = y + (nextY - y) * pulsePhase;
          
          final pulsePaint = Paint()
            ..style = PaintingStyle.fill
            ..color = nodeColor.withOpacity(0.05);
            
          canvas.drawCircle(Offset(pulseX, pulseY), 1.5, pulsePaint);
        }
      }
    }
  }
  
  void _paintSentienceParticles(Canvas canvas, Size size) {
    // Sentience particles - representing the AI's thoughts
    final random = Random(17);
    const particleCount = 120;
    
    final sentiencePaint = Paint()
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < particleCount; i++) {
      // Base position with a sense of organization
      final section = i % 6; // Organize into 6 regions
      final sectionWidth = size.width / 3;
      final sectionHeight = size.height / 2;
      
      final sectionX = (section % 3) * sectionWidth;
      final sectionY = (section ~/ 3) * sectionHeight;
      
      // Position within section
      final baseX = sectionX + random.nextDouble() * sectionWidth;
      final baseY = sectionY + random.nextDouble() * sectionHeight;
      
      // Movement pattern
      final speedFactor = 0.5 + 0.5 * random.nextDouble();
      final xPattern = sin(progress * pi * 2 * speedFactor + i * 0.1) * cos(i * 0.4);
      final yPattern = cos(progress * pi * 2 * speedFactor + i * 0.2) * sin(i * 0.3);
      
      final xOffset = size.width * 0.03 * xPattern;
      final yOffset = size.height * 0.03 * yPattern;
      
      final x = baseX + xOffset;
      final y = baseY + yOffset;
      
      // Color based on thought type
      final colorIndex = (i + section) % neuralColors.length;
      final particleColor = neuralColors[colorIndex];
      
      // Thought intensity varies with time
      final intensity = 0.4 + 0.6 * sin(progress * pi * 3 + i * 0.4);
      final opacity = 0.03 + 0.03 * intensity * random.nextDouble();
      
      sentiencePaint.color = particleColor.withOpacity(opacity);
      
      // Different shapes for different types of thoughts
      final shapeType = i % 4;
      final shapeSize = 1.0 + random.nextDouble() * intensity;
      
      switch (shapeType) {
        case 0: // Circle - logical thoughts
          canvas.drawCircle(Offset(x, y), shapeSize, sentiencePaint);
          break;
        case 1: // Square - structured thoughts
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: shapeSize * 1.8, height: shapeSize * 1.8),
            sentiencePaint
          );
          break;
        case 2: // Triangle - creative thoughts
          final path = Path();
          path.moveTo(x, y - shapeSize);
          path.lineTo(x + shapeSize * 0.866, y + shapeSize * 0.5);
          path.lineTo(x - shapeSize * 0.866, y + shapeSize * 0.5);
          path.close();
          canvas.drawPath(path, sentiencePaint);
          break;
        case 3: // Diamond - insight thoughts
          final path = Path();
          path.moveTo(x, y - shapeSize);
          path.lineTo(x + shapeSize, y);
          path.lineTo(x, y + shapeSize);
          path.lineTo(x - shapeSize, y);
          path.close();
          canvas.drawPath(path, sentiencePaint);
          break;
      }
      
      // Some particles have connection trails to nearby particles
      if (i % 8 == 0 && random.nextBool()) {
        // Find nearest particle within a certain region
        final connectionLength = size.width * 0.05 + size.width * 0.05 * random.nextDouble();
        
        // Calculate a direction
        final angle = pi * 2 * random.nextDouble();
        final connX = x + cos(angle) * connectionLength;
        final connY = y + sin(angle) * connectionLength;
        
        final connPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.3
          ..color = particleColor.withOpacity(opacity * 0.6);
          
        // Thought connection with slight curve
        final ctrlX = x + (connX - x) * 0.5 + sin(progress * pi) * 5;
        final ctrlY = y + (connY - y) * 0.5 + cos(progress * pi) * 5;
        
        final path = Path();
        path.moveTo(x, y);
        path.quadraticBezierTo(ctrlX, ctrlY, connX, connY);
        canvas.drawPath(path, connPaint);
      }
    }
  }
  
  void _paintEnergyFlow(Canvas canvas, Size size) {
    // Energy flow patterns across the entire mind-space
    final flowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
      
    const flowCount = 5;
    
    for (int flow = 0; flow < flowCount; flow++) {
      final flowProgress = (progress * 0.5 + flow * 0.2) % 1.0;
      
      // Each flow has a different pattern
      final flowPath = Path();
      
      // Flow start and end points
      final startX = flow % 2 == 0 ? 0 : size.width;
      final startY = size.height * (0.2 + 0.6 * (flow / flowCount));
      
      flowPath.moveTo(startX.toDouble(), startY);
      
      // Complex flow pattern
      const controlPoints = 4;
      double curX = startX.toDouble();
      double curY = startY;
      
      for (int cp = 0; cp < controlPoints; cp++) {
        final progress = cp / controlPoints;
        
        // Target position
        final targetX = flow % 2 == 0 
            ? startX + size.width * (progress + 1) / (controlPoints + 1)
            : startX - size.width * (progress + 1) / (controlPoints + 1);
            
        final targetY = startY + size.height * 0.2 * sin(cp * pi / 2 + flowProgress * pi * 2);
        
        // Control points for cubic curve
        final ctrlX1 = curX + (targetX - curX) * 0.4;
        final ctrlY1 = curY + size.height * 0.1 * cos(flowProgress * pi * 2 + cp);
        
        final ctrlX2 = curX + (targetX - curX) * 0.6;
        final ctrlY2 = targetY - size.height * 0.1 * sin(flowProgress * pi * 2 + cp + 1);
        
        flowPath.cubicTo(ctrlX1, ctrlY1, ctrlX2, ctrlY2, targetX, targetY);
        
        curX = targetX;
        curY = targetY;
      }
      
      // Energy flow with color gradient
      final colorA = neuralColors[flow % neuralColors.length];
      final colorB = neuralColors[(flow + 2) % neuralColors.length];
      
      flowPaint.shader = ui.Gradient.linear(
        Offset(startX.toDouble(), startY),
        Offset(flow % 2 == 0 ? size.width : 0, curY),
        [
          colorA.withOpacity(0.02),
          colorB.withOpacity(0.04),
          colorA.withOpacity(0.02),
        ]
      );
      
      canvas.drawPath(flowPath, flowPaint);
      
      // Energy surges along the flow
      final surgePaint = Paint()
        ..style = PaintingStyle.fill;
      
      const surgeCount = 3;
      for (int s = 0; s < surgeCount; s++) {
        final surgePhase = (flowProgress + s * 0.3) % 1.0;
        
        // Calculate position along cubic bezier
        final progress = surgePhase * controlPoints;
        final segment = progress.floor();
        final segmentProgress = progress - segment;
        
        if (segment >= controlPoints) continue;
        
        // Calculate the start point of the current segment
        final segStartX = segment == 0 ? startX : startX + size.width * segment / controlPoints * (flow % 2 == 0 ? 1 : -1);
        final segStartY = startY + size.height * 0.2 * sin((segment - 1) * pi / 2 + flowProgress * pi * 2);
        
        // Calculate the end point of the current segment
        final segEndX = startX + size.width * (segment + 1) / controlPoints * (flow % 2 == 0 ? 1 : -1);
        final segEndY = startY + size.height * 0.2 * sin(segment * pi / 2 + flowProgress * pi * 2);
        
        // Control points for this segment
        final segCtrlX1 = segStartX + (segEndX - segStartX) * 0.4;
        final segCtrlY1 = segStartY + size.height * 0.1 * cos(flowProgress * pi * 2 + segment);
        
        final segCtrlX2 = segStartX + (segEndX - segStartX) * 0.6;
        final segCtrlY2 = segEndY - size.height * 0.1 * sin(flowProgress * pi * 2 + segment + 1);
        
        // Calculate point on cubic bezier
        final mt = 1 - segmentProgress;
        
        final px = mt * mt * mt * segStartX + 
                 3 * mt * mt * segmentProgress * segCtrlX1 +
                 3 * mt * segmentProgress * segmentProgress * segCtrlX2 +
                 segmentProgress * segmentProgress * segmentProgress * segEndX;
                 
        final py = mt * mt * mt * segStartY + 
                 3 * mt * mt * segmentProgress * segCtrlY1 +
                 3 * mt * segmentProgress * segmentProgress * segCtrlY2 +
                 segmentProgress * segmentProgress * segmentProgress * segEndY;
                 
        // Draw energy surge
        surgePaint.color = colorB.withOpacity(0.06);
        canvas.drawCircle(Offset(px, py), 2.0, surgePaint);
        
        // Energy trail
        final trailPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..strokeCap = StrokeCap.round
          ..color = colorB.withOpacity(0.03);
        
        final trailLength = 0.1;
        final trailStartProgress = segmentProgress - trailLength;
        
        if (trailStartProgress >= 0) {
          final mts = 1 - trailStartProgress;
          
          final pxs = mts * mts * mts * segStartX + 
                   3 * mts * mts * trailStartProgress * segCtrlX1 +
                   3 * mts * trailStartProgress * trailStartProgress * segCtrlX2 +
                   trailStartProgress * trailStartProgress * trailStartProgress * segEndX;
                   
          final pys = mts * mts * mts * segStartY + 
                   3 * mts * mts * trailStartProgress * segCtrlY1 +
                   3 * mts * trailStartProgress * trailStartProgress * segCtrlY2 +
                   trailStartProgress * trailStartProgress * trailStartProgress * segEndY;
                   
          canvas.drawLine(Offset(pxs, pys), Offset(px, py), trailPaint);
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}