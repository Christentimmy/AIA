import 'package:aia/app/modules/onboaring/models/onboaring_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController
    with GetTickerProviderStateMixin {
  // Current page index
  final currentPage = 0.obs;
  late final PageController pageController;

  // Animation controllers
  late AnimationController visualEffectController;
  late AnimationController transitionController;
  late AnimationController floatingElementsController;

  // Animation values
  final visualEffectProgress = 0.0.obs;
  final transitionProgress = 1.0.obs;
  final floatingElementsValue = 0.0.obs;
  final isTransitioning = false.obs;

// Onboarding data with consistent blue tech colors
  final List<OnboardingItem> items = [
    OnboardingItem(
      title: "NEURAL CONVERSATIONS",
      description:
          "Experience a new era of AI communication with our neural network that understands context, nuance, and your personal preferences.",
      primaryColor: const Color(0xFF4FACFE),
      secondaryColor: const Color(0xFF00F2FE),
      accentColor: const Color(0xFFE2F3FD),
      iconData: Icons.psychology,
    ),
    OnboardingItem(
      title: "SECURE BY DESIGN",
      description:
          "Your conversations are protected with end-to-end encryption. Privacy isn't just a feature—it's the foundation of our platform.",
      primaryColor: const Color(0xFF2B86C5), // Adjusted to blueish
      secondaryColor: const Color(0xFF42A5F5), // Adjusted to blueish
      accentColor: const Color(0xFFE3F2FD), // Adjusted to blueish
      iconData: Icons.shield_outlined,
    ),
    OnboardingItem(
      title: "INFINITE IMAGINATION",
      description:
          "Explore new ideas and creative solutions with an AI that imagines possibilities beyond conventional thinking.",
      primaryColor: const Color(0xFF0D47A1), // Adjusted to deeper blue
      secondaryColor: const Color(0xFF1976D2), // Adjusted to medium blue
      accentColor: const Color(0xFFBBDEFB), // Adjusted to light blue
      iconData: Icons.auto_awesome,
    ),
  ];
  
  
  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Visual effect animation (constant motion)
    visualEffectController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    visualEffectController.addListener(() {
      visualEffectProgress.value = visualEffectController.value;
    });

    // Transition animation
    transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    transitionController.addListener(() {
      transitionProgress.value = transitionController.value;
    });

    // Floating elements animation
    floatingElementsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    floatingElementsController.addListener(() {
      floatingElementsValue.value = floatingElementsController.value;
    });
  }

  void nextPage() {
    if (isTransitioning.value) return;

    if (currentPage.value < items.length - 1) {
      _animateToNextPage();
    } else {
      _finishOnboarding();
    }
  }

  void _animateToNextPage() {
    isTransitioning.value = true;

    // Start transition out
    transitionController.reverse().then((_) {
      // Change page
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 10), // Quick transition
        curve: Curves.easeInOut,
      );

      // Start transition in
      Future.delayed(const Duration(milliseconds: 100), () {
        transitionController.forward().then((_) {
          isTransitioning.value = false;
        });
      });
    });
  }

  void skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    // Here you would navigate to your main app screen
    debugPrint('Onboarding completed, navigating to main app');
    // Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    visualEffectController.dispose();
    transitionController.dispose();
    floatingElementsController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
