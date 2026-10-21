import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'model/notification_model.dart';
import 'notification_controller.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _ScaffoldContent(
          controller: controller,
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.errorMessage.value.isNotEmpty &&
          !controller.hasNotifications) {
        return _ScaffoldContent(
          controller: controller,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bodyMediumRegular.copyWith(
                    color: AppColor.coolGrayText,
                  ),
                ),
                const SizedBox(height: 16),
                CommonButton(
                  label: 'Try Again',
                  onTap: controller.fetchNotifications,
                  backgroundColor: AppColor.blackColor,
                  foregroundColor: Colors.white,
                  height: 48,
                ),
              ],
            ),
          ),
        );
      }
      if (!controller.hasNotifications) return const _EmptyNotificationView();
      return _NotificationsListView(controller: controller);
    });
  }
}

class _ScaffoldContent extends StatelessWidget {
  final NotificationController controller;
  final Widget child;

  const _ScaffoldContent({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      appBar: _notificationAppBar(controller),
      body: child,
    );
  }
}

class _EmptyNotificationView extends StatelessWidget {
  const _EmptyNotificationView();

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colors.white,
      appBar: _notificationAppBar(Get.find<NotificationController>()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEEEEEE), width: 4),
              ),
              child: Center(
                child: Image.asset(
                  AppAssets.notificationImage,
                  color: const Color(0xff111111),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "You're all caught up",
              style: AppTextStyle.headlineLargeBold.copyWith(
                color: AppColor.blackShade1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "We'll keep you posted on your\nservice requests and latest offers",
              style: AppTextStyle.bodyMediumRegular.copyWith(
                color: AppColor.coolGrayText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CommonButton(
              label: 'Explore Services',
              onTap: () => Get.toNamed(AppRoutes.serviceScreen),
              backgroundColor: AppColor.blackColor,
              foregroundColor: Colors.white,
              height: 54,
            ),
          ],
        ),
      ),
    );
  }
}

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
        leading: const _BackButton(),
        title: Text(
          'Notifications',
          style: AppTextStyle.titleLargeBold.copyWith(
            color: AppColor.blackShade1,
          ),
        ),
        actions: [_MarkAllReadAction(controller: controller)],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchNotifications(showLoading: false),
        child: ListView.builder(
          controller: controller.scrollController,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          itemCount:
              controller.notifications.length +
              1 +
              (controller.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _SectionHeader(
                title: 'Recent',
                unreadCount: controller.unreadCount.value,
              );
            }
            if (index > controller.notifications.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final notification = controller.notifications[index - 1];
            return Obx(
              () => _NotificationCard(
                notification: notification,
                isUpdating: controller.updatingNotificationIds.contains(
                  notification.id,
                ),
                onTap: () => controller.markAsRead(notification),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int unreadCount;

  const _SectionHeader({required this.title, required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle.titleSmallSemiBold.copyWith(
              color: AppColor.blackShade1,
              fontSize: 15,
            ),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount unread',
                style: AppTextStyle.bodySmallMedium.copyWith(
                  color: AppColor.blackShade1,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final bool isUpdating;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.isUpdating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, iconBgColor, iconColor) = _notificationStyle(
      notification.type,
    );
    return InkWell(
      onTap: notification.isRead ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(
              icon: icon,
              bgColor: iconBgColor,
              iconColor: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyle.titleSmallSemiBold.copyWith(
                            color: AppColor.blackShade1,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (isUpdating)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (!notification.isRead)
                        const Padding(
                          padding: EdgeInsets.only(top: 6, left: 8),
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFF111111),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Read',
                            style: AppTextStyle.bodySmallMedium.copyWith(
                              color: AppColor.coolGrayText,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (!notification.isRead) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Unread',
                      style: AppTextStyle.bodySmallMedium.copyWith(
                        color: AppColor.blackColor,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),
                  Text(
                    notification.message,
                    style: AppTextStyle.bodySmallRegular.copyWith(
                      color: AppColor.primaryGrey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

(IconData, Color, Color) _notificationStyle(String type) {
  switch (type) {
    case 'technician_assigned':
      return (
        Icons.engineering_outlined,
        const Color(0xFFF0F0F0),
        const Color(0xFF111111),
      );
    default:
      return (
        Icons.notifications_none,
        const Color(0xFFEEEEEE),
        const Color(0xFF555555),
      );
  }
}

String _formatTime(DateTime dateTime) {
  final local = dateTime.toLocal();
  final difference = DateTime.now().difference(local);
  if (difference.inMinutes < 1) return 'Just now';
  if (difference.inHours < 1) return '${difference.inMinutes}m ago';
  if (difference.inDays < 1) return '${difference.inHours}h ago';
  if (difference.inDays == 1) return 'Yesterday';
  if (difference.inDays < 7) return '${difference.inDays} days ago';
  return '${local.day}/${local.month}/${local.year}';
}

class _NotificationIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _NotificationIcon({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

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

PreferredSizeWidget _notificationAppBar(NotificationController controller) =>
    AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: const _BackButton(),
      title: Text(
        'Notifications',
        style: AppTextStyle.titleLargeBold.copyWith(
          color: AppColor.blackShade1,
        ),
      ),
      actions: [_MarkAllReadAction(controller: controller)],
    );

class _MarkAllReadAction extends StatelessWidget {
  final NotificationController controller;

  const _MarkAllReadAction({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasUnread = controller.unreadCount.value > 0;
      final isUpdating = controller.isMarkingAllRead.value;
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: TextButton(
          onPressed: hasUnread && !isUpdating
              ? controller.markAllAsRead
              : null,
          style: TextButton.styleFrom(
            foregroundColor: AppColor.blackColor,
            disabledForegroundColor: AppColor.coolGrayText,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: Text(
            isUpdating ? 'Updating...' : (hasUnread ? 'Mark all read' : 'All read'),
            style: AppTextStyle.bodySmallMedium,
          ),
        ),
      );
    });
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFFEEEEEE),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.chevron_left,
          color: AppColor.blackShade1,
          size: 22,
        ),
      ),
    );
  }
}