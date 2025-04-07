import 'package:aia/app/modules/splash/controller/splash_controller.dart';
import 'package:aia/app/modules/splash/widgets/animated_text.dart';
import 'package:aia/app/modules/splash/widgets/futuristic_rings.dart';
import 'package:aia/app/modules/splash/widgets/grid_background.dart';
import 'package:aia/app/modules/splash/widgets/particle_system.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SplashScreen extends StatelessWidget {
const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetX controller
    final SplashController controller = Get.find<SplashController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF050A18), 
      body: Stack(
        children: [
          // Background grid lines
          const GridBackground(),
          
          // Particle effect
          Obx(() => ParticleSystem(
            progress: controller.particleProgress.value,
            particles: controller.particles,
          )),
          
          // Text and rings in center
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Rotating rings
                Obx(() => FuturisticRings(
                  rotationValue: controller.ringRotationValue.value,
                  scaleValue: controller.ringScaleValue.value,
                )),
                
                // Glow effect
                Obx(() => Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00A8FF).withOpacity(controller.glowValue.value * 0.3),
                        blurRadius: 30 * controller.glowValue.value,
                        spreadRadius: 5 * controller.glowValue.value,
                      ),
                    ],
                  ),
                )),
                
                // AIA Animated Text
                Obx(() => Transform.scale(
                  scale: controller.textScaleValue.value,
                  child: AnimatedAIAText(
                    letterOpacities: controller.letterOpacities,
                    letterOffsets: controller.letterOffsets,
                  ),
                )),
              ],
            ),
          ),
          
          // Tagline at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Obx(() => Opacity(
                opacity: controller.taglineOpacity.value,
                child: Text(
                  "THE FUTURE OF CONVERSATION",
                  style: controller.taglineTextStyle,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
