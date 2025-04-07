import 'package:aia/app/modules/onboaring/controller/onboaring_controller.dart';
import 'package:aia/app/modules/onboaring/widgets/floating_elements.dart';
import 'package:aia/app/modules/onboaring/widgets/holographic_display.dart';
import 'package:aia/app/modules/onboaring/widgets/nebulous_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// MAIN ONBOARDING SCREEN
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Background gradient with PageView
            Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.black,
                        controller
                            .items[controller.currentPage.value].primaryColor
                            .withOpacity(0.7),
                        controller
                            .items[controller.currentPage.value].secondaryColor
                            .withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Animated background elements
                      Positioned.fill(
                        child: Obx(() => AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: controller.transitionProgress.value,
                              child: NebulousBackground(
                                primaryColor: controller
                                    .items[controller.currentPage.value]
                                    .primaryColor,
                                secondaryColor: controller
                                    .items[controller.currentPage.value]
                                    .secondaryColor,
                                progress: controller.visualEffectProgress.value,
                              ),
                            )),
                      ),

                      // Floating elements
                      Positioned.fill(
                        child: Obx(() => AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: controller.transitionProgress.value,
                              child: FloatingElements(
                                animationValue:
                                    controller.floatingElementsValue.value,
                                primaryColor: controller
                                    .items[controller.currentPage.value]
                                    .primaryColor,
                                secondaryColor: controller
                                    .items[controller.currentPage.value]
                                    .secondaryColor,
                              ),
                            )),
                      ),
                    ],
                  ),
                )),

            // Content with page transition effect
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: (value) {
                controller.currentPage.value = value;
              },
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                return Obx(() => AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: controller.transitionProgress.value,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 400),
                        offset: Offset(0,
                            0.1 - (0.1 * controller.transitionProgress.value)),
                        child: _buildPage(controller, index),
                      ),
                    ));
              },
            ),

            // Bottom navigation
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: _buildBottomNavigation(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingController controller, int index) {
    final item = controller.items[index];

    return Column(
      children: [
        const SizedBox(height: 100),

        // Central visual element
        HoloGraphicDisplay(
          iconData: item.iconData,
          primaryColor: item.primaryColor,
          secondaryColor: item.secondaryColor,
          animationValue: controller.visualEffectProgress.value,
        ),

        const SizedBox(height: 60),

        // Text content
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
          ),
          child: Column(
            children: [
              Text(
                item.title,
                style: GoogleFonts.orbitron(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                item.description,
                style: GoogleFonts.rajdhani(
                  textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(OnboardingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          TextButton(
            onPressed: controller.skip,
            child: Text(
              "SKIP",
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Page indicators
          Row(
            children: List.generate(
              controller.items.length,
              (index) => Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _buildPageIndicator(
                      isActive: controller.currentPage.value == index,
                      color: controller
                          .items[controller.currentPage.value].primaryColor,
                    ),
                  )),
            ),
          ),

          // Next button with glow effect
          Obx(() => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: controller
                          .items[controller.currentPage.value].primaryColor
                          .withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      controller
                          .items[controller.currentPage.value].primaryColor,
                      controller
                          .items[controller.currentPage.value].secondaryColor,
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.isTransitioning.value
                      ? null
                      : controller.nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    controller.currentPage.value == controller.items.length - 1
                        ? "BEGIN"
                        : "NEXT",
                    style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPageIndicator({required bool isActive, required Color color}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
    );
  }
}
