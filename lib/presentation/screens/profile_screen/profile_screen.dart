import 'package:squadonsite/presentation/screens/plans_screen/plans_controller.dart';
import 'subscription_purchase_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  @override
  final controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: MyScaffold(
        backgroundColor: const Color(0xffF6F6F6),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              Obx(
                () => buildProfileInfo(
                  name: controller.userName.value.isEmpty
                      ? 'nav_profile'.tr
                      : controller.userName.value,
                  memberSince: controller.memberSince.value,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SubscriptionPurchaseCards(
                  controller: PlansController.ensure(),
                ),
              ),
              const SizedBox(height: 20),
              _SettingsCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileInfo({required String name, required String memberSince}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bodyLargeRegular.copyWith(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 10),
      ],
    );
  }

  Widget _buildHeader() {
    final double profileSize = Get.width * 0.28;
    final double headerHeight = Get.height * 0.18;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: Get.width,
          height: headerHeight,
          decoration: BoxDecoration(
            color: AppColor.blackColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(Get.width * 0.10),
              bottomRight: Radius.circular(Get.width * 0.10),
            ),
          ),
        ),
        Positioned(
          bottom: -(profileSize * 0.30),
          child: Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.blackColor, width: 1.5),
            ),
            child: Obx(() {
              final localImage = controller.profileImage.value;
              final remoteUrl = controller.profileImageUrl.value;
              if (localImage != null) {
                return ClipOval(
                  child: Image.file(localImage, fit: BoxFit.cover),
                );
              }
              if (Uri.tryParse(remoteUrl)?.hasAbsolutePath == true &&
                  (remoteUrl.startsWith('http://') ||
                      remoteUrl.startsWith('https://'))) {
                return ClipOval(
                  child: Image.network(
                    remoteUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => Image.asset(
                      AppAssets.onboardingImage2,
                      fit: BoxFit.cover,
                    ),
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                  ),
                );
              }
              return ClipOval(
                child: Image.asset(
                  AppAssets.onboardingImage2,
                  fit: BoxFit.cover,
                ),
              );
            }),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 20,
          child: _SupportAction().paddingOnly(right: 10),
        ),
      ],
    );
  }
}

class _SupportAction extends StatelessWidget {
  const _SupportAction();

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.chatSupportScreen,
      ) /*Get.toNamed(AppRoutes.supportScreen)*/,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.headset_mic_outlined, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}

// ─── Subscription Card ────────────────────────────────────────────────────────

class _SettingsCard extends GetView<ProfileController> {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.blackColor, width: 0.5),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.person_outline,
            label: 'profile_settings_personal'.tr,
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColor.blackColor,
              size: 20,
            ),
            onTap: () async {
              await Get.toNamed(AppRoutes.personalInformationScreen);
              await controller.loadProfile();
            },
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.notifications_none_outlined,
            label: 'profile_settings_notifications'.tr,
            trailing: Obx(
              () => Switch(
                value: controller.notificationsEnabled.value,
                onChanged: (v) => controller.notificationsEnabled.value = v,
                activeThumbColor: AppColor.blackColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeTrackColor: Color(0xffEEEEEE),
              ),
            ),
            onTap: () {},
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.language_outlined,
            label: 'profile_settings_language'.tr,
            flexibleTrailing: true,
            trailing: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.lightGreyColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const ValueKey('profile-language-dropdown'),
                    value: controller.selectedLanguage.value,
                    isExpanded: true,
                    selectedItemBuilder: (context) => [
                      for (final label in ['English', 'Español', 'العربية'])
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            (label).tr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: AppTextStyle.bodyMediumRegular.copyWith(
                      color: AppColor.blackShade1,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'english',
                        child: Text(('English').tr),
                      ),
                      DropdownMenuItem(
                        value: 'spanish',
                        child: Text(('Español').tr),
                      ),
                      DropdownMenuItem(
                        value: 'arabic',
                        child: Text(('العربية').tr),
                      ),
                    ],
                    onChanged: (language) {
                      if (language != null) controller.changeLanguage(language);
                    },
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.lock_reset_outlined,
            label: 'profile_settings_change_password'.tr,
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColor.blackColor,
              size: 20,
            ),
            onTap: () => Get.toNamed(AppRoutes.changePasswordScreen),
          ),
          _buildDivider(),
          // _SettingsTile(
          //   icon: Icons.menu_book_outlined,
          //   label: 'profile_settings_booking_safety'.tr,
          //   trailing: const Icon(
          //     Icons.chevron_right,
          //     color: AppColor.blackColor,
          //     size: 20,
          //   ),
          //   onTap: () => Get.toNamed(AppRoutes.bookingSafetyScreen),
          // ),
          // _buildDivider(),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            label: 'profile_settings_privacy'.tr,
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColor.blackColor,
              size: 20,
            ),
            onTap: () => Get.toNamed(AppRoutes.privacyPolicyScreen),
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.gavel_outlined,
            label: 'profile_settings_terms'.tr,
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColor.blackColor,
              size: 20,
            ),
            onTap: () => Get.toNamed(AppRoutes.termsConditionsScreen),
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.delete_outline,
            label: 'profile_delete_account'.tr,
            trailing: const SizedBox.shrink(),
            iconColor: Colors.black,
            labelColor: Colors.black,
            onTap: controller.onDeleteAccount,
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.logout_rounded,
            label: 'profile_logout'.tr,
            trailing: const SizedBox.shrink(),
            iconColor: Colors.black,
            labelColor: Colors.black,
            onTap: controller.onLogout,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    thickness: 1,
    color: AppColor.blackColor.withValues(alpha: 0.3),
    indent: 16,
    endIndent: 16,
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;
  final bool isLast;
  final bool stacked;
  final bool flexibleTrailing;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
    this.iconColor = AppColor.blackColor,
    this.labelColor = AppColor.blackShade1,
    this.isLast = false,
    this.stacked = false,
    this.flexibleTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    (label).tr,
                    maxLines: flexibleTrailing ? 1 : null,
                    overflow: flexibleTrailing ? TextOverflow.ellipsis : null,
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: labelColor,
                    ),
                  ),
                ),
                if (!stacked) ...[
                  const SizedBox(width: 8),
                  if (flexibleTrailing)
                    Expanded(flex: 2, child: trailing)
                  else
                    trailing,
                ],
              ],
            ),
            if (stacked) ...[const SizedBox(height: 12), trailing],
          ],
        ),
      ),
    );
  }
}

// ─── Refer & Earn ─────────────────────────────────────────────────────────────

class _ReferEarnSection extends GetView<ProfileController> {
  const _ReferEarnSection();

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Column(
      children: [
        Image.asset(AppAssets.referenceAndEarnImage),
        const SizedBox(height: 16),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xffF1F1F1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColor.blackColor.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    ('${'profile_referral_code'.tr}: ${controller.referralCode.value}')
                        .tr,
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: AppColor.blackShade1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      Clipboard.setData(
                        ClipboardData(text: controller.referralCode.value),
                      ).then(
                        (_) => AppSnackbar.show(
                          'profile_copied'.tr,
                          'profile_referral_copied'.tr,
                          duration: const Duration(seconds: 2),
                        ),
                      ),
                  child: const Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColor.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
