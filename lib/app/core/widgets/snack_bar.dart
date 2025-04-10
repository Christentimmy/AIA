

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showWarning(String message) {
    Get.snackbar(
      "Warning",
      message,
      backgroundColor: Colors.amber.shade700,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.black),
      shouldIconPulse: true,
      isDismissible: true,
    );
  }
}
