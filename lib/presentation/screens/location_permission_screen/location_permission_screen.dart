import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/app_text_style/app_text_style.dart';
import 'package:squadonsite/constant/common_widgets/common_button.dart';
import 'package:squadonsite/constant/common_widgets/my_scaffold.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/location_permission_screen/location_permission_controller.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationPermissionController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: MyScaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: AppColor.backgroundGradient),
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
                    Text(
                      'location_perm_title'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.headlineLargeBold.copyWith(
                        color: AppColor.blackShade1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'location_perm_subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bodyMediumRegular.copyWith(
                        color: AppColor.grey1Color,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => CommonButton(
                        isLoading: controller.isFetching.value,
                        label: 'location_perm_allow_btn'.tr,
                        onTap: () => _onAllowTapped(controller),
                        backgroundColor: AppColor.blackColor,
                        foregroundColor: Colors.white,
                        leadingIcon: const Icon(
                          Icons.near_me_rounded,
                          color: AppColor.blackColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CommonButton(
                      label: 'location_perm_manual_btn'.tr,
                      onTap: _onEnterManuallyTapped,
                      backgroundColor: AppColor.lightGrey2Color,
                      foregroundColor: AppColor.blackShade1,
                      border: Border.all(color: const Color(0xffDDDDDD)),
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

  void _onAllowTapped(LocationPermissionController controller) async {
    final point = await controller.requestLocationAndFetch();
    if (point != null &&
        Get.currentRoute == AppRoutes.locationPermissionScreen) {
      Get.toNamed(
        AppRoutes.mapPickerScreen,
        arguments: {'initialLatLng': point, 'addressOnboarding': true},
      );
    }
  }

  void _onEnterManuallyTapped() {
    Get.toNamed(
      AppRoutes.mapPickerScreen,
      arguments: {'addressOnboarding': true},
    );
  }
}
