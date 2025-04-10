// lib/app/modules/chat/widgets/listening_overlay.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ListeningOverlay extends StatelessWidget {
  final VoidCallback onTap;

  const ListeningOverlay({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              'assets/images/alt.json',
              repeat: true,
              width: 200,
              height: 200,
              addRepaintBoundary: true,
              fit: BoxFit.cover,
            ),
            const Text(
              "Tap to cancel",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
