import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_controller.dart';

// ─── Label enum ───────────────────────────────────────────────────────────────

enum AddressLabel { home, office, work, other }

extension AddressLabelX on AddressLabel {
  String get displayName {
    switch (this) {
      case AddressLabel.home:
        return 'Home';
      case AddressLabel.office:
        return 'Office';
      case AddressLabel.work:
        return 'Work';
      case AddressLabel.other:
        return 'Other';
    }
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

/// Handles the "Add / Edit Address" form.
///
/// Arguments received from [MapPickerScreen] via [Get.toNamed]:
/// ```dart
/// {
///   'addressLine': String,   // from reverse geocode
///   'city':        String,
///   'state':       String,
///   'zipcode':     String,
///   'addressId':   String,   // '' = new address; non-empty = edit
/// }
/// ```
class AddressFormController extends GetxController {
  // ── Form ──────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController addressLineController;
  late final TextEditingController cityController;
  late final TextEditingController stateController;
  late final TextEditingController zipcodeController;

  final houseController = TextEditingController();
  final buildingController = TextEditingController();
  final Rxn<LatLng> selectedLocation = Rxn<LatLng>();
  final area = ''.obs;
  bool _addressOnboarding = false;
  bool _changingLocation = false;
  bool _hasExistingLocation = false;

  final isDefault = false.obs;
  final saveToProfile = false.obs;
  final saveError = ''.obs;
  bool checkoutMode = false;
  bool isOriginallyDefault = false;
  bool _applyingLocation = false;

  bool get hasUsableLocation =>
      selectedLocation.value != null || (isEditMode && _hasExistingLocation);

  void _addressIdentityChanged() {
    if (_applyingLocation) return;
    selectedLocation.value = null;
    _hasExistingLocation = false;
    area.value = [
      addressLineController.text,
      cityController.text,
      stateController.text,
      zipcodeController.text,
    ].where((s) => s.trim().isNotEmpty).join(', ');
  }

  Future<void> changeLocation() async {
    if (isSaving.value || _changingLocation) return;
    _changingLocation = true;
    try {
      final initial = selectedLocation.value;
      final result = await Get.toNamed(
        AppRoutes.mapPickerScreen,
        arguments: {
          'returnSelection': true,
          'initialLatLng': initial,
          'displayAddress': area.value,
        },
        preventDuplicates: false,
      );
      if (!isClosed && result is Map<String, dynamic>) {
        _applyLocation(result);
      }
    } finally {
      _changingLocation = false;
    }
  }

  void _applyLocation(Map<String, dynamic> args) {
    _applyingLocation = true;
    final location = args['latLng'];
    selectedLocation.value = location is LatLng ? location : null;
    addressLineController.text = args['addressLine'] as String? ?? '';
    cityController.text = args['city'] as String? ?? '';
    stateController.text = args['state'] as String? ?? '';
    zipcodeController.text = args['zipcode'] as String? ?? '';
    final addressLine = addressLineController.text.trim();
    final fallbackArea = [
      cityController.text,
      stateController.text,
      zipcodeController.text,
    ].where((s) => s.trim().isNotEmpty).join(', ');
    area.value =
        args['display'] as String? ??
        (addressLine.isNotEmpty ? addressLine : fallbackArea);
    _applyingLocation = false;
  }

  // ── State ─────────────────────────────────────────────────────────────────
  final Rx<AddressLabel> selectedLabel = AddressLabel.home.obs;
  final RxBool isSaving = false.obs;

  /// Non-empty means we're editing an existing address.
  String _editAddressId = '';
  bool get isEditMode => _editAddressId.isNotEmpty;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initFromArguments();
  }

  void _initFromArguments() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    _addressOnboarding = args['addressOnboarding'] == true;
    checkoutMode = args['checkoutMode'] == true;
    isDefault.value = args['isDefault'] == true;
    isOriginallyDefault = isDefault.value;
    saveToProfile.value = !checkoutMode;

    addressLineController = TextEditingController(
      text: args['addressLine'] as String? ?? '',
    );
    cityController = TextEditingController(text: args['city'] as String? ?? '');
    stateController = TextEditingController(
      text: args['state'] as String? ?? '',
    );
    zipcodeController = TextEditingController(
      text: args['zipcode'] as String? ?? '',
    );

    _editAddressId =
        args['addressId'] as String? ?? args['id'] as String? ?? '';

    _applyLocation(args);
    _hasExistingLocation = isEditMode && area.value.trim().isNotEmpty;
    houseController.text =
        args['house'] as String? ?? args['buildingFloor'] as String? ?? '';
    buildingController.text =
        args['building'] as String? ?? args['street'] as String? ?? '';
    // Pre-select label if editing an existing address.
    final existingLabel =
        args['addressType'] as String? ?? args['label'] as String? ?? '';
    if (existingLabel.isNotEmpty) {
      selectedLabel.value = _labelFromString(existingLabel);
    }
    for (final field in [
      addressLineController,
      cityController,
      stateController,
      zipcodeController,
    ]) {
      field.addListener(_addressIdentityChanged);
    }
  }

  @override
  void onClose() {
    houseController.dispose();
    buildingController.dispose();
    addressLineController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipcodeController.dispose();
    super.onClose();
  }

  // ── Label picker ──────────────────────────────────────────────────────────

  void selectLabel(AddressLabel label) {
    selectedLabel.value = label;
  }

  AddressLabel _labelFromString(String s) {
    switch (s.toLowerCase()) {
      case 'work':
        return AddressLabel.work;
      case 'office':
        return AddressLabel.office;
      case 'home':
      case 'house':
        return AddressLabel.home;
      default:
        return AddressLabel.other;
    }
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> saveAddress() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final point = selectedLocation.value;
    if (isSaving.value) return;

    isSaving.value = true;
    try {
      saveError.value = '';
      final label = selectedLabel.value.displayName;
      final addressLine = addressLineController.text.trim();
      final city = cityController.text.trim();
      final state = stateController.text.trim();
      final zipcode = zipcodeController.text.trim();

      final draft = UserAddress(
        id: _editAddressId,
        label: label,
        addressLine: addressLine,
        city: city,
        state: state,
        zipcode: zipcode,
        latitude: point?.latitude,
        longitude: point?.longitude,
        house: houseController.text.trim(),
        building: buildingController.text.trim(),
        area: area.value,
        addressType: label,
        isDefault: isDefault.value,
      );
      if (checkoutMode && !saveToProfile.value) {
        Get.key.currentState?.pop(draft);
        return;
      }
      final repo = Get.find<ApiRepo>();
      final previousIds = checkoutMode
          ? (await repo.getAddresses()).map((a) => a.id).toSet()
          : <String>{};
      var updated = isEditMode
          ? await repo.updateAddress(draft)
          : await repo.addAddress(
              label: label,
              addressLine: addressLine,
              city: city,
              state: state,
              zipcode: zipcode,
              latitude: point?.latitude,
              longitude: point?.longitude,
              house: draft.house,
              building: draft.building,
              isDefault: isDefault.value,
            );
      if (isClosed) return;
      if (isEditMode && isDefault.value) {
        try {
          updated = await repo.setDefaultAddress(_editAddressId);
        } catch (_) {
          saveError.value =
              "Address updated, but could not set the default. Retry setting the default from your saved addresses."
                  .tr;
        }
      }
      if (Get.isRegistered<SelectLocationController>()) {
        Get.find<SelectLocationController>().applyAddresses(updated);
      }
      if (checkoutMode) {
        final saved = updated.firstWhereOrNull(
          (a) =>
              isEditMode ? a.id == _editAddressId : !previousIds.contains(a.id),
        );
        if (saved == null) {
          saveError.value =
              "Your address was saved, but could not be selected. Choose it from saved addresses."
                  .tr;
          saveToProfile.value = false;
          return;
        }
        Get.key.currentState?.pop(saved);
        return;
      }

      AppSnackbar.show(
        saveError.value.isEmpty ? "Success".tr : "Address updated".tr,
        saveError.value.isNotEmpty
            ? saveError.value
            : isEditMode
            ? "Address updated successfully.".tr
            : "Address saved successfully.".tr,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );

      // Pop all the way back to SelectLocationScreen (map + form = 2 pages).
      if (_addressOnboarding) {
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Get.until(
          (route) => route.settings.name == AppRoutes.selectLocationScreen,
        );
      }
    } catch (e) {
      if (isClosed) return;
      saveError.value = checkoutMode
          ? "Could not save to your profile. Retry, or turn off Save this address to my profile to use it for this booking."
                .tr
          : "Could not save address. Please try again.".tr;
      if (!checkoutMode) {
        AppSnackbar.show(
          "Error".tr,
          saveError.value,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }
}
