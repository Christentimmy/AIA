
// File: lib/modules/splash/widgets/animated_text.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedAIAText extends StatelessWidget {
  final List<RxDouble> letterOpacities;
  final List<RxDouble> letterOffsets;
  
  const AnimatedAIAText({
    super.key,
    required this.letterOpacities,
    required this.letterOffsets,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // First "A"
        _buildAnimatedLetter("A", 0),
        
        // "I"
        _buildAnimatedLetter("I", 1),
        
        // Second "A"
        _buildAnimatedLetter("A", 2),
      ],
    );
  }
  
  Widget _buildAnimatedLetter(String letter, int index) {
    return Obx(() => Opacity(
      opacity: letterOpacities[index].value,
      child: Transform.translate(
        offset: Offset(0, letterOffsets[index].value),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: letter == "I" ? 6 : 8),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00E5FF),
                Color(0xFF29B6F6),
              ],
            ).createShader(bounds),
            child: Text(
              letter,
              style: GoogleFonts.orbitron(
                textStyle: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}