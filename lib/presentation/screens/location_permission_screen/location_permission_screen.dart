import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:SystemUiOverlayStyle.dark,
      child: MyScaffold(
        body:   Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColor.backgroundGradient,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadowGrey.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Title ───────────────────────────────────────────
                    Text(
                      'location_perm_title'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.headlineLargeBold.copyWith(
                        color: AppColor.blackShade1,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Subtitle ────────────────────────────────────────
                    Text(
                      'location_perm_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.grey1Color,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Allow button ────────────────────────────────────
                    CommonButton(
                      label: 'location_perm_allow_btn'.tr,
                      onTap: _onAllowTapped,
                      backgroundColor: AppColor.blackColor,
                      foregroundColor: Colors.white,
                      leadingIcon: const Icon(
                        Icons.near_me_rounded,
                        color: AppColor.brownAccentPrimary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Enter Manually button ───────────────────────────
                    CommonButton(
                      label: 'location_perm_manual_btn'.tr,
                      onTap: _onEnterManuallyTapped,
                      backgroundColor: AppColor.lightGrey2Color,
                      foregroundColor: AppColor.blackShade1,
                      border: Border.all(color: const Color(0xffCFC4C5)),
                      boxShadow: const [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onAllowTapped() {
    // TODO: request location permission then navigate
    debugPrint('[Location] Allow tapped');
  }

  void _onEnterManuallyTapped() {
    Get.toNamed(AppRoutes.locationDetailScreen);
  }
}
