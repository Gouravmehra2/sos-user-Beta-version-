import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/common_widgets/common_bottom_sheet.dart';
import 'package:squadonsite/presentation/screens/onboarding_screen/widget/login_bottom_sheet.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  RxInt currentPage = 0.obs;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingStepList.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      CommonBottomSheet.show(child: LoginBottomSheet());
    }
  }

  void backPage() {
    if (currentPage.value > 0) {
      pageController.animateToPage(
        currentPage.value -1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  RxList<OnboardingStepModel> get onboardingStepList => [
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage1,
      titleKey: 'onboarding_slide1_title',
      descriptionKey: 'onboarding_slide1_desc',
    ),
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage2,
      titleKey: 'onboarding_slide2_title',
      descriptionKey: 'onboarding_slide2_desc',
    ),
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage1,
      titleKey: 'onboarding_slide3_title',
      descriptionKey: 'onboarding_slide3_desc',
    ),
  ].obs;
}

class OnboardingStepModel {
  String? imagePath;
  String? titleKey;
  String? descriptionKey;
  Widget? widget;

  OnboardingStepModel({
    this.imagePath,
    this.descriptionKey,
    this.titleKey,
    this.widget,
  });
}
