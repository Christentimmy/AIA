
// File: lib/modules/splash/models/particle.dart
import 'dart:math' as math;

class Particle {
  late double x;
  late double y;
  late double speed;
  late double size;
  late double opacity;
  late double direction;
  
  Particle(math.Random random) {
    reset(random, true);
  }
  
  void reset(math.Random random, bool initialSetup) {
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