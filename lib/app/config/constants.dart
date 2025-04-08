import 'package:get/get.dart';

class AppConstants {
  // Ring sizes
  static double ringWidth = Get.width * 0.78;
  static double ringHeight = Get.height * 0.359;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(seconds: 1);

  // Padding & Margin
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;

  // Corner radius
  static const double borderRadius = 12.0;

  // App-wide zIndex
  static const int overlayZIndex = 1000;

  // Max sizes
  static const int maxBioLength = 300;
}
