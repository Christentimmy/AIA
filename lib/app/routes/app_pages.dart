
import 'package:aia/app/modules/onboaring/bindings/onboarding_binding.dart';
import 'package:aia/app/modules/onboaring/views/onboarding_screen.dart';
import 'package:aia/app/modules/splash/bindings/splash_binding.dart';
import 'package:aia/app/modules/splash/views/splash_screen.dart';
import 'package:aia/app/routes/app_routes.dart';
import 'package:get/get.dart';


class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      binding: SplashBinding(),
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      binding: OnboardingBinding(),
      page: () => const OnboardingScreen(),
    ),
  ];
}
