import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';

class AppSnackbar {
  AppSnackbar._();

  static SnackbarController show(
    String title,
    String message, {
    Duration? duration = const Duration(seconds: 3),
    EdgeInsets? margin,
    TextButton? mainButton,
  }) {
    final isDark = Get.theme.brightness == Brightness.dark;
    final background = isDark ? Colors.white : AppColor.blackColor;
    final foreground = isDark ? AppColor.blackColor : Colors.white;

    return Get.snackbar(
      title.tr,
      message.tr,
      duration: duration,
      snackPosition: SnackPosition.TOP,
      snackStyle: SnackStyle.FLOATING,
      backgroundColor: background,
      colorText: foreground,
      borderColor: foreground.withValues(alpha: 0.22),
      borderWidth: 1,
      borderRadius: 12,
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      mainButton: mainButton,
      barBlur: 0,
      animationDuration: const Duration(milliseconds: 250),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
