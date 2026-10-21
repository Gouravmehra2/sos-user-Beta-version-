import 'package:squadonsite/core/services/firebase_notification_service.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';
import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'dart:io';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/common_widgets/common_dialog.dart';

class ProfileController extends GetxController {
  final RxBool isLoadingProfile = false.obs;

  // Profile image
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxString profileImageUrl = ''.obs;

  // User info
  final RxString userName = ''.obs;
  final RxString memberSince = ''.obs;
  final RxString walletBalance = '\$56.7'.obs;
  final RxInt couponCount = 4.obs;
  final RxString savingsThisMonth = '\$124.50'.obs;

  // Settings
  final RxBool notificationsEnabled = true.obs;
  RxString get selectedLanguage =>
      LanguageService.to.currentLanguage.value.name.obs;
  // Subscription
  final RxString subscriptionStatus = 'ACTIVE'.obs;
  final RxString subscriptionName = 'SquadCare+'.obs;

  // Referral
  final RxString referralCode = 'jag1202'.obs;

  @override
  void onInit() {
    super.onInit();
    _applyUser(Get.find<AuthSession>().user);
    loadProfile();
    PlansController.ensure().refreshHistory();
  }

  Future<void> loadProfile() async {
    final session = Get.find<AuthSession>();
    if (!session.hasToken) return;

    isLoadingProfile.value = true;
    try {
      final response = await Get.find<ApiRepo>().me();
      if (!response.success || response.user == null) {
        throw Exception('Invalid profile response');
      }
      _applyUser(response.user);
      await session.update(response);
    } catch (_) {
      _showRequestError("Unable to load your profile. Please try again.".tr);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  void _applyUser(AuthUser? user) {
    if (user == null) return;
    userName.value = user.name.trim();
    profileImageUrl.value = user.profileImageUrl.trim();
    final createdAt = DateTime.tryParse(user.createdAt);
    memberSince.value = createdAt?.year.toString() ?? '';
  }

  Future<void> pickProfileImage() async {
    final file = await CommonDialog.showImagePickerDialog();
    if (file != null) {
      profileImage.value = File(file.path);
    }
  }

  void onEditName() {}

  void onViewBenefits() {
    // CommonBottomSheet.show(child: const BenefitsBottomSheet());
  }

  void onMenuTap(String item) {}

  Future<void> onDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      title: "Delete account?".tr,
      message:
          "Are you sure you want to delete this account? This action is irreversible."
              .tr,
      confirmLabel: "profile_delete_account".tr,
    );
    if (!confirmed) return;

    try {
      await Get.find<DioClient>().delete(ApiEndpoints.me);
      await _clearLocalDataAndOpenOnboarding();
    } catch (_) {
      _showRequestError("Unable to delete your account. Please try again.".tr);
    }
  }

  Future<void> onLogout() async {
    final confirmed = await _showConfirmationDialog(
      title: "Logout?".tr,
      message: "Are you sure you want to logout from this device?".tr,
      confirmLabel: "Logout".tr,
    );
    if (!confirmed) return;

    final session = Get.find<AuthSession>();
    try {
      await Get.find<DioClient>().post(
        ApiEndpoints.logout,
        data: {
          'refreshToken': session.refreshToken,
          'fcmToken': ?await FirebaseNotificationService.getToken(),
        },
      );
      await _clearLocalDataAndOpenOnboarding();
    } catch (_) {
      _showRequestError("Unable to logout. Please try again.".tr);
    }
  }

  Future<bool> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text((title).tr),
        content: Text((message).tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text("Cancel".tr),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text((confirmLabel).tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result == true;
  }

  Future<void> _clearLocalDataAndOpenOnboarding() async {
    await Get.find<SocialAuthService>().signOutGoogle();
    await Get.find<AuthSession>().clearLocalData();
    if (Get.isRegistered<PlansController>()) {
      await Get.find<PlansController>().refreshHistory();
    }
    Get.offAllNamed(AppRoutes.onboardingScreen);
  }

  void _showRequestError(String message) {
    AppSnackbar.show(
      "Request failed".tr,
      message,
      duration: const Duration(seconds: 3),
    );
  }

  void changeLanguage(String lang) {
    LanguageService.to.setLanguage(
      AppLanguage.values.byName(lang.toLowerCase()),
    );
  }
}
