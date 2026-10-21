import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/presentation/screens/security_screen/security_controller.dart';

class SecurityScreen extends GetView<SecurityController> {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: AppColor.blackColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "profile_settings_security".tr,
          style: AppTextStyle.titleLargeBold.copyWith(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Account Security ─────────────────────────────────────────
          _SecurityCard(
            headerIcon: Icons.shield_outlined,
            headerTitle: 'Account Security',
            children: [
              _SecurityTile(
                icon: Icons.lock_outline,
                title: "Change Password".tr,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColor.coolGrayText,
                  size: 20,
                ),
                onTap: controller.onChangePassword,
              ),
              _SecurityDivider(),
              _SecurityTile(
                icon: Icons.dialpad,
                title: "Security PIN".tr,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColor.coolGrayText,
                  size: 20,
                ),
                onTap: controller.onSecurityPin,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Verification ─────────────────────────────────────────────
          _SecurityCard(
            headerIcon: Icons.verified_user_outlined,
            headerTitle: 'Verification',
            children: [
              Obx(
                () => _SecurityTile(
                  icon: Icons.smartphone_outlined,
                  title: "Mobile Verification".tr,
                  trailing: _VerifiedBadge(
                    isVerified: controller.isMobileVerified.value,
                  ),
                  onTap: () {},
                ),
              ),
              _SecurityDivider(),
              Obx(
                () => _SecurityTile(
                  icon: Icons.mail_outline,
                  title: "Email Verification".tr,
                  trailing: _VerifiedBadge(
                    isVerified: controller.isEmailVerified.value,
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Active Session ───────────────────────────────────────────
          _SecurityCard(
            headerIcon: Icons.fingerprint,
            headerTitle: 'Active Session',
            children: [
              _SecurityTile(
                icon: Icons.smartphone_outlined,
                title: "Current Device".tr,
                subtitle: controller.currentDevice,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColor.coolGrayText,
                  size: 20,
                ),
                onTap: controller.onCurrentDevice,
              ),
              _SecurityDivider(),
              _SecurityTile(
                icon: Icons.history,
                title: "Last Login".tr,
                subtitle: controller.lastLogin,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Delete Account ───────────────────────────────────────────
          _DeleteAccountCard(onTap: controller.onDeleteAccount),
        ],
      ),
    );
  }
}

// ── Card wrapper ─────────────────────────────────────────────────────────────

class _SecurityCard extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final List<Widget> children;

  const _SecurityCard({
    required this.headerIcon,
    required this.headerTitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                _IconBox(icon: headerIcon),
                const SizedBox(width: 12),
                Text(
                  (headerTitle).tr,
                  style: AppTextStyle.titleSmallSemiBold.copyWith(
                    color: AppColor.blackShade1,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ── List tile ────────────────────────────────────────────────────────────────

class _SecurityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SecurityTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _IconBox(icon: icon, size: 36, iconSize: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (title).tr,
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: AppColor.coolGrayText,
                      fontSize: 14,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      (subtitle!).tr,
                      style: AppTextStyle.bodySmallRegular.copyWith(
                        color: AppColor.coolGrayText,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

// ── Verified badge ───────────────────────────────────────────────────────────

class _VerifiedBadge extends StatelessWidget {
  final bool isVerified;

  const _VerifiedBadge({required this.isVerified});

  @override
  Widget build(BuildContext context) {
    if (!isVerified) {
      return Text(
        "Not Verified".tr,
        style: AppTextStyle.bodySmallMedium.copyWith(color: Colors.redAccent),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Verified".tr,
          style: AppTextStyle.bodySmallMedium.copyWith(
            color: AppColor.green2Color,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.check_circle, size: 16, color: AppColor.green2Color),
      ],
    );
  }
}

// ── Delete account card ──────────────────────────────────────────────────────

class _DeleteAccountCard extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteAccountCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delete Account".tr,
                    style: AppTextStyle.titleSmallSemiBold.copyWith(
                      color: Colors.redAccent,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Permanently remove account".tr,
                    style: AppTextStyle.bodySmallRegular.copyWith(
                      color: AppColor.coolGrayText,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.redAccent, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Shared helpers ───────────────────────────────────────────────────────────

class _IconBox extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;

  const _IconBox({required this.icon, this.size = 40, this.iconSize = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: iconSize, color: AppColor.blackColor),
    );
  }
}

class _SecurityDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.lightGreyColor,
      indent: 16,
      endIndent: 16,
    );
  }
}
