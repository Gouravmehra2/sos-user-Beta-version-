import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  @override
  var controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 50),
            buildProfileInfo(name: 'Gourav', memberSince: '2019'),
            const SizedBox(height: 20),
            _QuickActions(),
            const SizedBox(height: 20),
            _SubscriptionCard(),
            const SizedBox(height: 20),
            _WalletCouponRow(),
            const SizedBox(height: 20),
            _SettingsCard(),
            const SizedBox(height: 20),
            _ReferEarnSection(),
            const SizedBox(height: 20),
            _LogoutButton(),
            const SizedBox(height: 32),
          ],
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
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 10),
        Text(
          '${'profile_member_since'.tr} $memberSince',
          style: AppTextStyle.bodyLargeRegular.copyWith(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
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
            color: AppColor.brownAccentPrimary,
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
              border: Border.all(
                color: AppColor.brownAccentPrimary,
                width: 1.5,
              ),
            ),
            child: Image.asset(AppAssets.onboardingImage2),
          ),
        ),
        // Positioned(
        //   bottom: -(profileSize * 0.40),
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     padding: EdgeInsets.all(6),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       shape: BoxShape.circle,
        //       border: Border.all(
        //         color: AppColor.brownAccentPrimary,
        //         width: 1.5,
        //       ),
        //     ),
        //     child: Icon(
        //       Icons.edit,
        //       size: 15,
        //       color: AppColor.brownAccentPrimary,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// ─── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem(icon: Icons.calendar_today_outlined, labelKey: 'profile_quick_bookings'),
      _ActionItem(icon: Icons.payment_outlined, labelKey: 'profile_quick_payment'),
      _ActionItem(icon: Icons.location_on_outlined, labelKey: 'profile_quick_addresses'),
      _ActionItem(icon: Icons.headset_mic_outlined, labelKey: 'profile_quick_support', route: AppRoutes.supportScreen),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    ).paddingSymmetric(horizontal: 10);
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final String? route;

  const _ActionItem({required this.icon, required this.labelKey, this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { if (route != null) Get.toNamed(route!); },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8EC),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.brownAccentPrimary, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            labelKey.tr,
            style: AppTextStyle.labelSmallMedium.copyWith(
              color: AppColor.blackColor2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Subscription Card ────────────────────────────────────────────────────────

class _SubscriptionCard extends GetView<ProfileController> {
  const _SubscriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.brownAccentPrimary,
        borderRadius: BorderRadius.circular(20),
        gradient: AppColor.subscriptionCardGradient
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: 0,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.workspace_premium, size: 80, color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    controller.subscriptionStatus.value,
                    style: AppTextStyle.labelSmallMedium.copyWith(
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Text(
                  controller.subscriptionName.value,
                  style: AppTextStyle.headlineLargeBold.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: controller.onViewBenefits,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColor.brownAccentPrimary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        'profile_view_benefits'.tr,
                        style: AppTextStyle.buttonSmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'profile_savings_label'.tr,
                        style: AppTextStyle.labelSmallRegular.copyWith(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                      ),
                      Obx(
                        () => Text(
                          controller.savingsThisMonth.value,
                          style: AppTextStyle.headlineSmallSemiBold.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Wallet & Coupon Row ──────────────────────────────────────────────────────

class _WalletCouponRow extends GetView<ProfileController> {
  const _WalletCouponRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _PillCard(
              imagePath: AppAssets.walletImage,
              imageHeight: 25.0,
              labelWidget: Obx(
                () => Text(
                  '${'profile_wallet'.tr}: ${controller.walletBalance.value}',
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.walletScreen);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _PillCard(
              imageHeight: 23.0,
              imagePath: AppAssets.couponImage,
              labelWidget: Obx(
                () => Text(
                  '${'profile_coupons'.tr} (${controller.couponCount.value})',
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.couponScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PillCard extends StatelessWidget {
  final Widget labelWidget;
  final VoidCallback onTap;
  final String imagePath;
  final double imageHeight;

  const _PillCard({ required this.labelWidget, required this.onTap,required this.imagePath,this.imageHeight = 20});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.brownAccentPrimary, width: 0.5),
        ),
        child: Row(
          children: [
            Image.asset(imagePath,height: imageHeight,color: AppColor.brownAccentPrimary),
            const SizedBox(width: 8),
            Flexible(child: labelWidget),
          ],
        ),
      ),
    );
  }
}

// ─── Settings Card ────────────────────────────────────────────────────────────

class _SettingsCard extends GetView<ProfileController> {
  const _SettingsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.brownAccentPrimary, width: 0.5),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.person_outline,
            label: 'profile_settings_personal'.tr,
            trailing: const Icon(Icons.chevron_right, color: AppColor.brownAccentPrimary, size: 20),
            onTap: () {
              Get.toNamed(AppRoutes.personalInformationScreen);
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
                activeColor: AppColor.brownAccentPrimary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeTrackColor: Color(0xffFFEBC8),
              ),
            ),
            onTap: () {},
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.language_outlined,
            label: 'profile_settings_language'.tr,
            trailing: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColor.brownAccentPrimary.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.brownAccentPrimary,
                      blurStyle: BlurStyle.outer,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['English', 'Spanish'].map((lang) {
                    final selected = controller.selectedLanguage.value == lang;
                    return GestureDetector(
                      onTap: () => controller.changeLanguage(lang),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6, right: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: selected ? AppColor.brownAccentPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? AppColor.brownAccentPrimary : Colors.white,
                          ),
                        ),
                        child: Text(
                          'language_${lang.toLowerCase()}'.tr,
                          style: AppTextStyle.labelSmallMedium.copyWith(
                            color: selected ? Colors.white : AppColor.blackShade1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            onTap: () {},
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.security_outlined,
            label: 'profile_settings_security'.tr,
            trailing: const Icon(Icons.chevron_right, color: AppColor.brownAccentPrimary, size: 20),
            onTap: () {
              Get.toNamed(AppRoutes.securityScreen);
            },
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.menu_book_outlined,
            label: 'profile_settings_booking_safety'.tr,
            trailing: const Icon(Icons.chevron_right, color: AppColor.brownAccentPrimary, size: 20),
            onTap: () => Get.toNamed(AppRoutes.bookingSafetyScreen),
          ),
          _buildDivider(),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            label: 'profile_settings_privacy'.tr,
            trailing: const Icon(Icons.chevron_right, color: AppColor.brownAccentPrimary, size: 20),
            onTap: () => Get.toNamed(AppRoutes.privacyPolicyScreen),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    thickness: 1,
    color: AppColor.brownAccentPrimary.withValues(alpha: 0.3),
    indent: 16,
    endIndent: 16,
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColor.brownAccentPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyle.titleSmallSemiBold.copyWith(
                  color: AppColor.blackShade1,
                ),
              ),
            ),
            trailing,
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
              border: Border.all(color: AppColor.brownAccentPrimary.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${'profile_referral_code'.tr}: ${controller.referralCode.value}',
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Clipboard.setData(
                    ClipboardData(text: controller.referralCode.value),
                  ).then(
                    (_) => Get.snackbar(
                      'profile_copied'.tr,
                      'profile_referral_copied'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    ),
                  ),
                  child: const Icon(Icons.copy, size: 16, color: AppColor.brownAccentPrimary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Logout ───────────────────────────────────────────────────────────────────

class _LogoutButton extends GetView<ProfileController> {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: controller.onLogout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE5E5),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFFCDD2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
              const SizedBox(width: 8),
              Text(
                'profile_logout'.tr,
                style: AppTextStyle.buttonMedium.copyWith(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
