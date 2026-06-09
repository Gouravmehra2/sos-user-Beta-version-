import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_bottom_sheet.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_orbit_design.dart';
import 'package:squadonsite/constant/common_widgets/common_soft_blob_gradient.dart';
import 'package:squadonsite/constant/common_widgets/common_worm_effect.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_controller.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/widget/login_bottom_sheet.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      useSafeArea: true,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Background blobs ──────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            child: CommonSoftBlobGradient(color: AppColor.blueColor),
          ),
          Positioned(
            right: -20,
            top: Get.height / 3,
            child: CommonSoftBlobGradient(
              color: AppColor.brownColor,
              opacity: 0.50,
              boxShape: BoxShape.rectangle,
            ),
          ),

          // ── PageView ──────────────────────────────────────────────────────
          Obx(() {
            final currentIndex = controller.currentPage.value;

            return PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.onboardingStepList.length,
              itemBuilder: (context, index) {
                final data = controller.onboardingStepList[index];

                return SizedBox(
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Animated image / widget ───────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.08, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: index == 2
                            ? const CircularOrbitWidget(key: ValueKey('orbit'))
                            : Image.asset(
                                data.imagePath ?? '',
                                key: ValueKey(data.imagePath),
                              ),
                      ),

                      const SizedBox(height: 50),

                      // ── Worm indicator ────────────────────────────────────
                      CommonWormIndicator(
                        count: controller.onboardingStepList.length,
                        currentIndex: currentIndex,
                      ),

                      const SizedBox(height: 10),

                      // ── Animated title + description ──────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.12),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          key: ValueKey(index),
                          spacing: 20,
                          children: [
                            Text(
                              data.title ?? '',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.titleLargeBold.copyWith(
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              data.description ?? '',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.titleSmallMedium.copyWith(
                                fontSize: 16,
                                color: AppColor.coolGrayText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),

          // ── Next button ───────────────────────────────────────────────────
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: CommonButton(
              label: 'Next',
              onTap: controller.nextPage,
              trailingIcon: Icon(
                Icons.arrow_forward,
                color: AppColor.brownAccentPrimary,
              ),
            ).paddingSymmetric(horizontal: 20),
          ),
          //app bar (back icon && skip button)
          Positioned(
            top: 0,
            left: 20,
            right: 20,
            child: Obx(
                  () => Stack(
                children: [
                  if (controller.currentPage.value > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: controller.backPage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.darkGray.withValues(alpha: 0.05),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        CommonBottomSheet.show(child: LoginBottomSheet());
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "Skip",
                          style: AppTextStyle.titleMediumMedium.copyWith(
                            fontSize: 16,
                            color: AppColor.darkGray,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
