import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/presentation/screens/dashboard/widgets/custom_bottom_navigation_tab.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_controller.dart';

class DashboardController extends GetxController {
  static const plansIndex = 2;
  static const bookingsIndex = 3;
  int selectedIndex = 0;

  final List<BottomNavItemModel> bottomList = [
    BottomNavItemModel(
      label: "nav_home",
      filledIcon: AppAssets.filledHomeIcon,
      outlineIcon: AppAssets.outlinedHomeIcon,
    ),
    BottomNavItemModel(
      label: "nav_services",
      filledIcon: AppAssets.filledServiceIcon,
      outlineIcon: AppAssets.outlinedServiceIcon,
    ),
    const BottomNavItemModel(
      label: 'Plans',
      icon: Icons.workspace_premium_outlined,
      pulseWhenInactive: true,
    ),
    BottomNavItemModel(
      label: "nav_bookings",
      filledIcon: AppAssets.filledCalendarIcon,
      outlineIcon: AppAssets.outlinedCalendarIcon,
    ),
    BottomNavItemModel(
      label: "nav_profile",
      filledIcon: AppAssets.filledPersonIcon,
      outlineIcon: AppAssets.outlinedPersonIcon,
    ),
  ];

  void changeIndex({int index = 1}) {
    if (index < 0 || index >= bottomList.length) {
      return;
    }
    // Cached tabs stay mounted. Refresh an existing history controller when
    // opening Bookings; a lazy controller fetches its first page in onInit.
    if (index == bookingsIndex &&
        Get.isRegistered<BookingHistoryController>() &&
        !Get.isPrepared<BookingHistoryController>()) {
      unawaited(Get.find<BookingHistoryController>().fetchBookings());
    }
    if (selectedIndex == index) return;
    selectedIndex = index;
    update();
  }

  void openServiceCategory({
    required String title,
    required String categoryId,
  }) {
    final serviceController = Get.isRegistered<ServiceController>()
        ? Get.find<ServiceController>()
        : Get.put(
            ServiceController(
              initialTitle: title,
              initialCategoryId: categoryId,
            ),
          );

    serviceController.setCategory(title: title, categoryId: categoryId);

    selectedIndex = 1;
    update();
  }
}
