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

  RxList<OnboardingStepModel> onboardingStepList = [
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage1,
      title: 'Instant\nExpert Help',
      description:
          'Book trusted technicians and home\nservices anytime, anywhere.',
    ),
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage2,
      title: 'Verified Service\nExperts',
      description:
          'Every professional is background-\nverified and quality-checked.',
    ),
    OnboardingStepModel(
      imagePath: AppAssets.onboardingImage1,
      title: 'One App.\nEvery Service.',
      description:
          'From appliance repair to emergency\nsupport — Squad On Site has you\ncovered.',
    ),
  ].obs;
}

class OnboardingStepModel {
  String? imagePath;
  String? title;
  String? description;
  Widget? widget;

  OnboardingStepModel({
    this.imagePath,
    this.description,
    this.title,
    this.widget,
  });
}
