

import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ChatAnimationMixin {
  late AnimationController pulseAnimationController;
  late AnimationController backgroundAnimController;

  final RxDouble animationValue = 0.0.obs;
  final RxDouble backgroundAnimValue = 0.0.obs;

  void initAnimations(TickerProvider vsync) {
    pulseAnimationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    pulseAnimationController.addListener(() {
      animationValue.value = pulseAnimationController.value;
    });

    backgroundAnimController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 30),
    )..repeat();

    backgroundAnimController.addListener(() {
      backgroundAnimValue.value = backgroundAnimController.value;
    });
  }

  void disposeAnimations() {
    pulseAnimationController.dispose();
    backgroundAnimController.dispose();
  }
}
