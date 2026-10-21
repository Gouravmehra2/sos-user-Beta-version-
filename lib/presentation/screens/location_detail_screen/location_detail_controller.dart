import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

enum SaveAsType { home, office, other }

class LocationDetailController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController searchController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  final Rx<SaveAsType> selectedSaveAs = SaveAsType.home.obs;
  final RxBool isLocationLoading = false.obs;
  final RxBool hasCurrentLocation = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLocationIfPermissionAlreadyGranted();
  }

  void selectSaveAs(SaveAsType type) => selectedSaveAs.value = type;

  void onSearchChanged(String value) {
    debugPrint('[LocationDetail] search: $value');
  }

  Future<void> useCurrentLocation() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();
      if (requested == LocationPermission.denied ||
          requested == LocationPermission.deniedForever) {
        AppSnackbar.show(
          "Location access required".tr,
          "Please allow location access so we can use your current location."
              .tr,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppSnackbar.show(
        "Location access denied".tr,
        "Please enable location access in app settings to continue.".tr,
      );
      return;
    }

    await _fetchCurrentLocation();
  }

  Future<void> _loadCurrentLocationIfPermissionAlreadyGranted() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _fetchCurrentLocation();
    }
  }

  Future<void> _fetchCurrentLocation() async {
    isLocationLoading.value = true;
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final placemarks = await Geocoding().placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;
      final address = [
        place.name,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((value) => value != null && value.isNotEmpty).join(', ');

      if (address.isNotEmpty) {
        searchController.text = address;
        hasCurrentLocation.value = true;
      } else {
        searchController.text = 'Current location';
        hasCurrentLocation.value = true;
      }
    } catch (_) {
      hasCurrentLocation.value = false;
      searchController.text = '';
      AppSnackbar.show(
        "Unable to fetch location".tr,
        "Please try again or allow location access.".tr,
      );
    } finally {
      isLocationLoading.value = false;
    }
  }

  void confirmLocation() {
    if (!hasCurrentLocation.value) {
      AppSnackbar.show(
        "Location required".tr,
        "Please allow current location access to continue.".tr,
      );
      return;
    }

    if (!formKey.currentState!.validate()) return;

    final payload = {
      'search': searchController.text.trim(),
      'house': houseController.text.trim(),
      'apartment': apartmentController.text.trim(),
      'landmark': landmarkController.text.trim(),
      'saveAs': selectedSaveAs.value.name,
    };

    debugPrint('[LocationDetail] confirm: $payload');
    Get.toNamed(AppRoutes.dashboardScreen);
  }

  @override
  void onClose() {
    searchController.dispose();
    houseController.dispose();
    apartmentController.dispose();
    landmarkController.dispose();
    super.onClose();
  }
}
