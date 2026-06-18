import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';

/// Model for a saved address entry
class SavedAddress {
  final String type; // e.g. "Home", "Work", "Other"
  final String fullAddress;
  final String distance; // e.g. "3 m", "0 m", "300 m"
  final Color iconBgColor;
  final String icon;
  final bool isSelected;
  final Color iconColor;

  const SavedAddress({
    required this.type,
    required this.fullAddress,
    required this.distance,
    required this.iconBgColor,
    required this.icon,
    required this.iconColor,
    this.isSelected = false,
  });

  SavedAddress copyWith({bool? isSelected}) => SavedAddress(
    type: type,
    fullAddress: fullAddress,
    distance: distance,
    iconBgColor: iconBgColor,
    icon: icon,
    isSelected: isSelected ?? this.isSelected,
    iconColor: iconColor,
  );
}

class SelectLocationController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  /// Index of the currently selected saved address (-1 = none)
  final RxInt selectedIndex = RxInt(0);

  final List<SavedAddress> savedAddresses = [
    SavedAddress(
      type: 'Home',
      fullAddress:
          'Ep 331 Inside Saidan Gate Tanchi Wali Gali, Bajwa Colony, Jalandhar, Punjab 144008',
      distance: '3 m',
      iconBgColor: Color(0xFFEDE9FE),
      // light purple
      icon: AppAssets.outlinedHomeIcon,
      iconColor: AppColor.purpleColor,
      isSelected: true,
    ),
    SavedAddress(
      type: 'Work',
      fullAddress:
          'CXO Suites, Ground Floor, IT Park, Sector 22, Panchkula, Haryana 134109, India',
      distance: '0 m',
      iconBgColor: Color(0xFFFFEDD5),
      // light orange
      icon: AppAssets.workOutlineIcon,
      iconColor: AppColor.darkBrown,
    ),
    SavedAddress(
      type: 'Other',
      fullAddress:
          'R118, PG Kiran, Sector 91, Sahibzada Ajit Singh Nagar, Mohali, Punjab, 140308, India',
      distance: '300 m',
      iconBgColor: Color(0xFFDCFCE7),
      // light green
      icon: AppAssets.outlinedHomeIcon,
      iconColor: AppColor.greenColor,
    ),
  ];

  void onSearchChanged(String value) => searchQuery.value = value;

  void selectAddress(int index) => selectedIndex.value = index;

  void onUseCurrentLocation() {
    // TODO: request location permission + reverse geocode
  }

  void onAddNewAddress() {
    // TODO: navigate to add-address form
  }

  void onRequestFromFriend() {
    // TODO: share link / deep-link flow
  }

  void onEditAddress(int index) {
    // TODO: navigate to edit-address screen
  }

  void onDeleteAddress(int index) {
    // TODO: delete address from backend
  }

  void onShareAddress(int index) {
    // TODO: share address
  }

  void onViewAll() {
    // TODO: navigate to all addresses screen
  }

  void onConfirmLocation() {
    // TODO: confirm & navigate back / forward
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
