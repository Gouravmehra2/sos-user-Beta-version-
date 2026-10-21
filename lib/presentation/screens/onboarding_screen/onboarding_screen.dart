import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_bottom_sheet.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/common_orbit_design.dart';
import 'package:squadonsite/constant/common_widgets/common_worm_effect.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/onboarding_controller.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/widget/login_bottom_sheet.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.put(OnboardingController());
  final languageService = LanguageService.to;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() {
          final current = languageService.currentLanguage.value;
          final showBack = controller.currentPage.value > 0;
          return AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: showBack
                ? InkWell(
                    onTap: controller.backPage,
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.darkGray.withValues(alpha: 0.05),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            title: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<AppLanguage>(

                  value: current,

                  // Keep the dropdown content compact.
                  isExpanded: false,

                  // White dropdown menu.
                  dropdownColor: Colors.white,

                  // Remove default extra padding.
                  padding: EdgeInsets.zero,

                  // Center selected item.
                  alignment: Alignment.center,

                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColor.darkGray,
                  ),

                  items: [
                    DropdownMenuItem<AppLanguage>(
                      value: AppLanguage.arabic,
                      child: Text('language_arabic'.tr),
                    ),
                    DropdownMenuItem<AppLanguage>(
                      value: AppLanguage.english,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇺🇸', style: TextStyle(fontSize: 16)),

                            const SizedBox(width: 8),

                            Text(
                              'language_english'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.titleMediumMedium.copyWith(
                                fontSize: 14,
                                color: AppColor.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    DropdownMenuItem<AppLanguage>(
                      value: AppLanguage.spanish,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🇪🇸', style: TextStyle(fontSize: 16)),

                            const SizedBox(width: 8),

                            Text(
                              'language_spanish'.tr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.titleMediumMedium.copyWith(
                                fontSize: 14,
                                color: AppColor.darkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  onChanged: (val) {
                    if (val == null) return;

                    languageService.setLanguage(val);
                  },
                ),
              ),
            ),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () => CommonBottomSheet.show(child: LoginBottomSheet()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      'onboarding_skip'.tr,
                      style: AppTextStyle.titleMediumMedium.copyWith(
                        fontSize: 16,
                        color: AppColor.darkGray,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),

      // ── Next button — Scaffold places this before body, so body never hides behind it
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 12),
        child: SizedBox(
          height: 52,
          child: CommonButton(
            label: 'onboarding_next'.tr,
            onTap: controller.nextPage,
            trailingIcon: Icon(
              Icons.arrow_forward,
              color: AppColor.brownAccentPrimary,
            ),
          ),
        ),
      ),

      body: Obx(() {
        final currentIndex = controller.currentPage.value;
        return PageView.builder(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          itemCount: controller.onboardingStepList.length,
          itemBuilder: (context, index) {
            final data = controller.onboardingStepList[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                final imgHeight = (constraints.maxHeight * 0.42).clamp(
                  140.0,
                  320.0,
                );
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: constraints.maxHeight * 0.04,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight * 0.92,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Image / orbit ─────────────────────────────────
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.08, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: index == 2
                              ? const CircularOrbitWidget(
                                  key: ValueKey('orbit'),
                                )
                              : Image.asset(
                                  data.imagePath ?? '',
                                  key: ValueKey(data.imagePath),
                                  height: imgHeight,
                                  fit: BoxFit.contain,
                                ),
                        ),

                        SizedBox(height: constraints.maxHeight * 0.04),

                        // ── Worm indicator ────────────────────────────────
                        CommonWormIndicator(
                          count: controller.onboardingStepList.length,
                          currentIndex: currentIndex,
                        ),

                        SizedBox(height: constraints.maxHeight * 0.02),

                        // ── Title + description ───────────────────────────
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.12),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              ),
                          child: Column(
                            key: ValueKey(index),
                            children: [
                              Text(
                                data.titleKey?.tr ?? '',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleLargeBold.copyWith(
                                  fontSize: (size.width * 0.068).clamp(22, 32),
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.018),
                              Text(
                                data.descriptionKey?.tr ?? '',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.titleSmallMedium.copyWith(
                                  fontSize: (size.width * 0.038).clamp(13, 18),
                                  color: AppColor.coolGrayText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
