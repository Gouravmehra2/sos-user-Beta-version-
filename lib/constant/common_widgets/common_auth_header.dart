import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final double headerHeight = size.height * 0.38;
    final double blobSize = size.width * 0.38;
    return SizedBox(
      height: headerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// TOP IMAGE
          Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),

          /// TOP LEFT BLOB
          Positioned(
            top: -blobSize * 0.2,
            left: -blobSize * 0.2,
            child: CommonSoftBlobGradient(
              color: AppColor.darkGray,
              opacity: 0.15,
              height: blobSize,
              width: blobSize,
              boxShape: BoxShape.rectangle,
            ),
          ),

          /// BACK BUTTON
          if (showBackButton)
            Positioned(
              top: padding.top + 8,
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
      ),
    );
  }
}

class AuthLayout extends StatelessWidget {
  final String imagePath;
  final Widget body;

  const AuthLayout({super.key, required this.imagePath, required this.body});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            CommonAuthHeader(imagePath: imagePath),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
