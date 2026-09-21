import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  controller.hasNotifications.value
        ? _NotificationsListView(controller: controller)
        :
        _EmptyNotificationView());
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyNotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _BackButton(),
        title: Text('Notifications', style: AppTextStyle.titleLargeBold.copyWith(color: AppColor.blackShade1)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration:  BoxDecoration(
                color: Color(0xFFFFEFDA),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFFFEFDA),width: 4.0)
              ),
              child:  Center(
                child: Image.asset(AppAssets.notificationImage,color: Color(0xffA5732F),),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "You're all caught up",
              style: AppTextStyle.headlineLargeBold.copyWith(color: AppColor.blackShade1),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "We'll keep you posted on your\nservice requests and latest offers",
              style: AppTextStyle.bodyMediumRegular.copyWith(color: AppColor.coolGrayText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CommonButton(
              label: 'Explore Services',
              onTap: () => Get.toNamed(AppRoutes.serviceScreen),
              backgroundColor: AppColor.brownAccentPrimary,
              foregroundColor: Colors.white,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── List View ────────────────────────────────────────────────────────────────

class _NotificationsListView extends StatelessWidget {
  final NotificationController controller;
  const _NotificationsListView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _BackButton(),
        title: Text('Notifications', style: AppTextStyle.titleLargeBold.copyWith(color: AppColor.blackShade1)),
        actions: [
          GestureDetector(
            onTap: controller.clearAll,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.brownAccentPrimary),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Clear All',
                style: AppTextStyle.bodySmallMedium.copyWith(color: AppColor.brownAccentPrimary),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _SectionHeader(title: 'This week'),
          ...controller.thisWeek.map((n) => _NotificationCard(item: n)),
          const SizedBox(height: 8),
          _SectionHeader(title: 'Earlier this week'),
          ...controller.earlierThisWeek.map((n) => _NotificationCard(item: n)),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: AppTextStyle.titleSmallSemiBold.copyWith(color: AppColor.blackShade1, fontSize: 15)),
    );
  }
}

// ─── Notification Card ────────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _NotificationIcon(icon: item.icon, bgColor: item.iconBgColor, iconColor: item.iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: AppTextStyle.titleSmallSemiBold.copyWith(color: AppColor.blackShade1, fontSize: 16)),
                    if (item.time != null)
                      Text(item.time!, style: AppTextStyle.bodySmallRegular.copyWith(color: AppColor.coolGrayText)),
                  ],
                ),
              ),
              if (item.hasLiveTrack)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2EDE8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Live Track', style: AppTextStyle.labelMediumSemiBold.copyWith(color: AppColor.brownAccentPrimary)),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Body text
          if (item.type == NotificationType.serviceUpdate)
            RichText(
              text: TextSpan(
                style: AppTextStyle.bodySmallRegular.copyWith(color: AppColor.primaryGrey, height: 1.5),
                children: [
                  const TextSpan(text: 'Technician '),
                  TextSpan(text: 'Alex Sterling', style: AppTextStyle.bodySmallMedium.copyWith(color: AppColor.blackShade1)),
                  const TextSpan(text: ' is currently on his way to your location for the scheduled HVAC maintenance.\n'),
                  TextSpan(text: 'Estimated arrival: 14:15.', style: AppTextStyle.bodySmallMedium.copyWith(color: AppColor.blackShade1)),
                ],
              ),
            )
          else
            Text(item.body, style: AppTextStyle.bodySmallRegular.copyWith(color: AppColor.primaryGrey, height: 1.5)),

          // Promotion banner
          if (item.hasPromotion) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF5DEB3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.promotionText!, style: AppTextStyle.titleLargeBold.copyWith(color: AppColor.brownAccentPrimary, fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(item.body, style: AppTextStyle.bodySmallRegular.copyWith(color: AppColor.primaryGrey)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CommonButton(
              label: 'Claim Reward',
              onTap: () {},
              backgroundColor: AppColor.brownAccentPrimary,
              foregroundColor: Colors.white,
              height: 44,
              borderRadius: 10,
            ),
          ],

          // View Live Map button
          if (item.hasViewMap) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEEEEEE)),
                  child: const Icon(Icons.person, size: 18, color: AppColor.coolGrayText),
                ),
                const SizedBox(width: 10),
                CommonButton(
                  label: 'View Live Map',
                  onTap: () => Get.toNamed(AppRoutes.liveTrackingScreen),
                  backgroundColor: AppColor.brownAccentPrimary,
                  foregroundColor: Colors.white,
                  fullWidth: false,
                  height: 38,
                  borderRadius: 20,
                  paddingHorizontal: 18,
                  textStyle: AppTextStyle.buttonMedium,
                ),
              ],
            ),
          ],

          // Download Receipt
          if (item.hasDownloadReceipt) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Download Receipt →',
                style: AppTextStyle.bodySmallMedium.copyWith(color: AppColor.brownAccentPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Notification Icon ────────────────────────────────────────────────────────

class _NotificationIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  const _NotificationIcon({required this.icon, required this.bgColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}

// ─── Back Button ──────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
        child: const Icon(Icons.chevron_left, color: AppColor.blackShade1, size: 22),
      ),
    );
  }
}
