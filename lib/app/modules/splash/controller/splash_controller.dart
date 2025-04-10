// File: lib/modules/splash/controllers/splash_controller.dart
import 'package:aia/app/core/controller/storage_controller.dart';
import 'package:aia/app/modules/splash/models/particle_model.dart';
import 'package:aia/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // Controllers for different animation elements
  late AnimationController textController;
  late AnimationController particleController;
  late AnimationController ringController;
  late AnimationController glowController;
  late AnimationController letterController;

  // Animation values
  final textScaleValue = 0.0.obs;
  final ringRotationValue = 0.0.obs;
  final ringScaleValue = 0.0.obs;
  final glowValue = 0.0.obs;
  final particleProgress = 0.0.obs;
  final taglineOpacity = 0.0.obs;

  // Letter animations
  final letterOpacities = List.generate(3, (_) => 0.0.obs);
  final letterOffsets = List.generate(3, (_) => 50.0.obs);

  // Particles
  final particles = <Particle>[];
  final int particleCount = 30;
  final random = math.Random();

  // Text styles
  TextStyle get taglineTextStyle => GoogleFonts.rajdhani(
        textStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 3,
        ),
      );

  final _storageController = Get.find<StorageController>();

  @override
  void onInit() {
    super.onInit();

    // Initialize particles
    for (int i = 0; i < particleCount; i++) {
      particles.add(Particle(random));
    }

    // Initialize controllers
    _initializeControllers();

    // Start animations
    _startAnimations();
  }

  void _initializeControllers() {
    // Text scale animation
    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    textController.addListener(() {
      // TweenSequence for the bounce effect
      double value;
      if (textController.value < 0.5) {
        // Scale up to 1.2
        value = 2.4 * textController.value;
      } else {
        // Scale down to 1.0
        value = 1.2 - 0.2 * (textController.value - 0.5) * 2;
      }
      textScaleValue.value = value;
    });

    // Letter animations
    letterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    letterController.addListener(() {
      taglineOpacity.value = letterController.value;

      // Update individual letter animations
      for (int i = 0; i < 3; i++) {
        final startPoint = i * 0.2;
        final endPoint = 0.6 + i * 0.2;

        // Calculate offset progress
        if (letterController.value < startPoint) {
          letterOffsets[i].value = 50.0;
        } else if (letterController.value > endPoint) {
          letterOffsets[i].value = 0.0;
        } else {
          final progress =
              (letterController.value - startPoint) / (endPoint - startPoint);
          letterOffsets[i].value = 50.0 * (1 - progress);
        }

        // Calculate opacity progress
        final opacEndPoint = 0.4 + i * 0.2;
        if (letterController.value < startPoint) {
          letterOpacities[i].value = 0.0;
        } else if (letterController.value > opacEndPoint) {
          letterOpacities[i].value = 1.0;
        } else {
          final progress = (letterController.value - startPoint) /
              (opacEndPoint - startPoint);
          letterOpacities[i].value = progress;
        }
      }
    });

    // Particle animation
    particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    particleController.addListener(() {
      particleProgress.value = particleController.value;
    });

    // Ring animation
    ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    ringController.addListener(() {
      ringRotationValue.value = 2 * math.pi * ringController.value;

      // TweenSequence for ring scale
      double value;
      if (ringController.value < 0.4) {
        // Scale up to 1.2
        value = 3.0 * ringController.value;
      } else {
        // Scale down to 1.0
        value = 1.2 - 0.2 * (ringController.value - 0.4) / 0.6;
      }
      ringScaleValue.value = value;
    });

    // Glow animation
    glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    glowController.addListener(() {
      // Sine wave for pulsing effect
      glowValue.value = math.sin(glowController.value * math.pi);
    });
  }

  void _startAnimations() {
    // Start animations in sequence
    ringController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      letterController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      particleController.forward();
      textController.forward();
      glowController.repeat();
    });

    // Navigate to next screen after splash
    Future.delayed(const Duration(milliseconds: 5000), () async {
      // Handle navigation to next screen
      await _navigateToNextScreen();
    });
  }

  Future<void> _navigateToNextScreen() async {
    bool status = await _storageController.getUserStatus();
    if (status) {
      Get.offAllNamed(AppRoutes.chatscreen);
    } else {
      await _storageController.saveStatus("true");
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    textController.dispose();
    letterController.dispose();
    particleController.dispose();
    ringController.dispose();
    glowController.dispose();
    super.onClose();
  }
}
