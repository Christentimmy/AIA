

import 'dart:math';
import 'package:flutter/material.dart';

class FuturisticChatBackgroundPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;
  
  FuturisticChatBackgroundPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    _paintHexagonGrid(canvas, size);
    _paintFlowingWaves(canvas, size);
    _paintNetworkNodes(canvas, size);
    _paintDigitalPulse(canvas, size);
  }
  
  void _paintHexagonGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;
    
    final hexSize = size.width / 14;
    final horizontalSpacing = hexSize * 1.5;
    final verticalSpacing = hexSize * sqrt(3);
    
    for (int row = -1; row < size.height / verticalSpacing + 1; row++) {
      for (int col = -1; col < size.width / horizontalSpacing + 1; col++) {
        final isOffset = row % 2 == 0;
        final x = col * horizontalSpacing + (isOffset ? hexSize * 0.75 : 0);
        final y = row * verticalSpacing;
        
        // Draw hexagon
        if (x.isFinite && y.isFinite) {
          final path = Path();
          for (int i = 0; i < 6; i++) {
            final angle = (60 * i - 30) * pi / 180;
            final pointX = x + hexSize * cos(angle);
            final pointY = y + hexSize * sin(angle);
            
            if (i == 0) {
              path.moveTo(pointX, pointY);
            } else {
              path.lineTo(pointX, pointY);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
        }
      }
    }
  }
  
  void _paintFlowingWaves(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = primaryColor.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    
    final numWaves = 3;
    final waveHeight = size.height / 18;
    
    for (int i = 0; i < numWaves; i++) {
      final waveOffset = size.height * 0.2 + i * size.height * 0.25;
      final amplitude = waveHeight * (1 - i * 0.2);
      final frequency = 6 + i * 0.5;
      final phase = progress * 2 * pi - i * pi / 3;
      
      final path = Path();
      path.moveTo(0, waveOffset);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = waveOffset + 
                  sin(x / size.width * frequency * pi + phase) * amplitude + 
                  sin(x / size.width * frequency * 0.5 * pi - phase * 0.7) * amplitude * 0.5;
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, wavePaint);
    }
  }
  
  void _paintNetworkNodes(Canvas canvas, Size size) {
    final random = Random(42);
    final nodePaint = Paint()
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    final nodeCount = 12;
    final nodes = List.generate(nodeCount, (i) {
      final baseX = (i % 4) * (size.width / 3) + size.width / 6;
      final baseY = (i ~/ 4) * (size.height / 3) + size.height / 6;
      
      // Add dynamic movement to nodes
      final xOffset = 30 * cos(progress * pi + i * 0.7);
      final yOffset = 25 * sin(progress * pi * 0.8 + i * 0.4);
      
      return Offset(
        (baseX + xOffset + random.nextDouble() * 20).clamp(10, size.width - 10),
        (baseY + yOffset + random.nextDouble() * 20).clamp(10, size.height - 10)
      );
    });
    
    // Draw connections between nearby nodes
    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final distance = (nodes[i] - nodes[j]).distance;
        if (distance < size.width / 4) {
          final opacity = 0.04 * (1 - distance / (size.width / 4));
          final useSecondary = (i + j) % 2 == 0;
          linePaint.color = (useSecondary ? secondaryColor : primaryColor).withOpacity(opacity);
          canvas.drawLine(nodes[i], nodes[j], linePaint);
        }
      }
    }
    
    // Draw nodes
    for (int i = 0; i < nodes.length; i++) {
      final pulseEffect = 0.7 + 0.3 * sin(progress * 2 * pi + i * 0.8);
      final nodeSize = 1.5 + random.nextDouble() * 1.5 * pulseEffect;
      
      final useSecondary = i % 3 == 0;
      nodePaint.color = (useSecondary ? secondaryColor : primaryColor).withOpacity(0.15 * pulseEffect);
      
      canvas.drawCircle(nodes[i], nodeSize, nodePaint);
      
      // Draw pulse effect for some nodes
      if (i % 4 == 0) {
        final pulsePhase = (progress * 2 + i * 0.2) % 1.0;
        if (pulsePhase < 0.5) {
          final pulseOpacity = 0.1 * (1 - pulsePhase / 0.5);
          final pulseSize = nodeSize * (1 + pulsePhase * 4);
          nodePaint.color = (useSecondary ? secondaryColor : primaryColor).withOpacity(pulseOpacity);
          canvas.drawCircle(nodes[i], pulseSize, nodePaint);
        }
      }
    }
  }
  
  void _paintDigitalPulse(Canvas canvas, Size size) {
    final pulsePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    
    // Create 2 horizontal data streams
    for (int stream = 0; stream < 2; stream++) {
      final y = size.height * (0.3 + stream * 0.4);
      final path = Path();
      
      // Start position
      double currentX = -20 + (progress * size.width) % 60;
      path.moveTo(currentX, y);
      
      // Create digital-looking pulse
      final random = Random(stream + 42);
      while (currentX < size.width + 20) {
        final segmentLength = 10 + random.nextDouble() * 30;
        final direction = random.nextBool() ? -1 : 1;
        final verticalOffset = direction * (2 + random.nextDouble() * 4);
        
        // Add horizontal segment
        currentX += segmentLength;
        path.lineTo(currentX, y);
        
        // Add vertical segment
        path.lineTo(currentX, y + verticalOffset);
        
        // Add horizontal segment
        final smallSegment = 4 + random.nextDouble() * 12;
        currentX += smallSegment;
        path.lineTo(currentX, y + verticalOffset);
        
        // Return to baseline
        path.lineTo(currentX, y);
      }
      
      // Set color based on stream
      pulsePaint.color = (stream == 0 ? primaryColor : secondaryColor).withOpacity(0.07);
      canvas.drawPath(path, pulsePaint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}