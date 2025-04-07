// ONBOARDING DATA MODEL
import 'package:flutter/material.dart';

// ONBOARDING DATA MODEL
class OnboardingItem {
  final String title;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final IconData iconData;
  
  OnboardingItem({
    required this.title,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.iconData,
  });
}