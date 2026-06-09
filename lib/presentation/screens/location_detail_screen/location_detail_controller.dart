import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';

enum SaveAsType { home, office, other }

class LocationDetailController extends GetxController {
  // ── Form ──────────────────────────────────────────────────────────────────

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  // ── Text controllers ──────────────────────────────────────────────────────

  final TextEditingController searchController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  // ── Save-as selection ─────────────────────────────────────────────────────

  final Rx<SaveAsType> selectedSaveAs = SaveAsType.home.obs;

  void selectSaveAs(SaveAsType type) => selectedSaveAs.value = type;

  // ── Actions ───────────────────────────────────────────────────────────────


  void onSearchChanged(String value) {
    // TODO: trigger place autocomplete
    debugPrint('[LocationDetail] search: $value');
  }

  void useCurrentLocation() {
    // TODO: get GPS coordinates and reverse-geocode
    debugPrint('[LocationDetail] Use current location tapped');
  }

  void confirmLocation() {
    if (!formKey.currentState!.validate()) return;

    Get.toNamed(AppRoutes.dashboardScreen);

    final payload = {
      'search': searchController.text.trim(),
      'house': houseController.text.trim(),
      'apartment': apartmentController.text.trim(),
      'landmark': landmarkController.text.trim(),
      'saveAs': selectedSaveAs.value.name,
    };

    // TODO: save address and navigate forward
    debugPrint('[LocationDetail] confirm: $payload');
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onClose() {
    searchController.dispose();
    houseController.dispose();
    apartmentController.dispose();
    landmarkController.dispose();
    super.onClose();
  }
}
