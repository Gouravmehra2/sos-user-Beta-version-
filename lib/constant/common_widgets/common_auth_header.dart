import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/common_soft_blob_gradient.dart';

class CommonAuthHeader extends StatelessWidget {
  final String imagePath;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Widget? child;

  const CommonAuthHeader({
    super.key,
    required this.imagePath,
    this.showBackButton = true,
    this.onBackTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// TOP IMAGE
        Positioned(
          left: 20,
          right: 20,
          top: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              imagePath,
              height: Get.height * 0.35,
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// TOP LEFT BLOB
        Positioned(
          top: -30,
          left: -30,
          child: CommonSoftBlobGradient(
            color: AppColor.brownColor,
            opacity: 0.30,
            height: 150,
            width: 150,
            boxShape: BoxShape.rectangle,
          ),
        ),

        /// BACK BUTTON
        if (showBackButton)
          Positioned(
            top: 12,
            left: 20,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: onBackTap ?? () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.shadowGrey.withValues(alpha: 0.30),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        /// EXTRA CHILD
        if (child != null) child!,
      ],
    );
  }
}

class AuthLayout extends StatelessWidget {
  final String imagePath;
  final Widget body;

  const AuthLayout({
    super.key,
    required this.imagePath,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CommonAuthHeader(
          imagePath: imagePath,
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: body,
        ),
      ],
    );
  }
}