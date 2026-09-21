import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotificationType { serviceUpdate, payment, profileVerified, promotion, security, requestPending }

class NotificationItem {
  final String title;
  final String? time;
  final String body;
  final NotificationType type;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool hasLiveTrack;
  final bool hasViewMap;
  final bool hasDownloadReceipt;
  final bool hasPromotion;
  final String? promotionText;
  final bool hasClaimReward;

  const NotificationItem({
    required this.title,
    this.time,
    required this.body,
    required this.type,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.hasLiveTrack = false,
    this.hasViewMap = false,
    this.hasDownloadReceipt = false,
    this.hasPromotion = false,
    this.promotionText,
    this.hasClaimReward = false,
  });
}

class NotificationController extends GetxController {
  final RxBool hasNotifications = true.obs;

  final List<NotificationItem> thisWeek = const [
    NotificationItem(
      title: 'Service Update',
      time: 'Just now',
      body: 'Technician Alex Sterling is currently on his way to your location for the scheduled HVAC maintenance.\nEstimated arrival: 14:15.',
      type: NotificationType.serviceUpdate,
      icon: Icons.engineering_outlined,
      iconBgColor: Color(0xFFF2EDE8),
      iconColor: Color(0xFFA5732F),
      hasLiveTrack: true,
      hasViewMap: true,
    ),
    NotificationItem(
      title: 'Payment Successful',
      time: '2 hours ago',
      body: 'Payment of \$85.00 for invoice #8821 was processed successfully.',
      type: NotificationType.payment,
      icon: Icons.check_circle_outline,
      iconBgColor: Color(0xFFE8F5E9),
      iconColor: Color(0xFF229D4F),
      hasDownloadReceipt: true,
    ),
  ];

  final List<NotificationItem> earlierThisWeek = const [
    NotificationItem(
      title: 'Profile Verified',
      time: null,
      body: 'Your identity documents have been approved.',
      type: NotificationType.profileVerified,
      icon: Icons.shield_outlined,
      iconBgColor: Color(0xFFEEEEEE),
      iconColor: Color(0xFF555555),
    ),
    NotificationItem(
      title: 'Promotion',
      time: '5 days ago',
      body: 'Exclusive for your next technical consultation.',
      type: NotificationType.promotion,
      icon: Icons.card_giftcard_outlined,
      iconBgColor: Color(0xFFF2EDE8),
      iconColor: Color(0xFFA5732F),
      hasPromotion: true,
      promotionText: '15% OFF',
      hasClaimReward: true,
    ),
    NotificationItem(
      title: 'New Login Detected',
      time: 'Yesterday',
      body: 'A new login was detected from a Chrome browser on a MacOS device in Seattle, USA.',
      type: NotificationType.security,
      icon: Icons.security_outlined,
      iconBgColor: Color(0xFFFFEBEE),
      iconColor: Color(0xFFE53935),
    ),
    NotificationItem(
      title: 'Request Pending',
      time: 'Yesterday',
      body: "Expert evaluation for 'Smart Home Optimization' is still in review. We'll update you soon.",
      type: NotificationType.requestPending,
      icon: Icons.assignment_outlined,
      iconBgColor: Color(0xFFEEEEEE),
      iconColor: Color(0xFF555555),
    ),
  ];

  void clearAll() {
    hasNotifications.value = false;
  }
}
