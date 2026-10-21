import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/constant/app_assets/app_assets.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/helpers/location_permission_helper.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';

// ─── Icon helpers ─────────────────────────────────────────────────────────────

/// Returns the SVG asset path for a given address label.
String _iconFor(String label) {
  switch (label.toLowerCase()) {
    case 'work':
    case 'office':
      return AppAssets.workOutlineIcon;
    default:
      return AppAssets.outlinedHomeIcon;
  }
}

/// Returns a neutral icon tint colour. All tiles use the same monochromatic
/// palette the rest of the app uses.
Color _iconColorFor(String label) {
  switch (label.toLowerCase()) {
    case 'work':
    case 'office':
      return AppColor.blackShade2;
    default:
      return AppColor.primaryGrey;
  }
}

// ─── Screen state enum ────────────────────────────────────────────────────────

enum LocationScreenState { loading, success, error }

// ─── Controller ───────────────────────────────────────────────────────────────

class SelectLocationController extends GetxController {
  // ── Search ────────────────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // ── Screen state ──────────────────────────────────────────────────────────
  final Rx<LocationScreenState> screenState = LocationScreenState.loading.obs;
  final RxString errorMessage = ''.obs;

  // ── Address data ──────────────────────────────────────────────────────────
  /// Live list of addresses fetched from GET /api/auth/me.
  final RxList<UserAddress> addresses = <UserAddress>[].obs;
  final RxBool showAllAddresses = false.obs;
  int _fetchVersion = 0;
  bool _selectionOnly = false;
  bool _returnOnSelection = false;
  bool _persistDefaultOnSelection = false;

  int get visibleAddressCount => showAllAddresses.value
      ? addresses.length
      : (addresses.length > 3 ? 3 : addresses.length);

  bool get canViewAll =>
      screenState.value == LocationScreenState.success &&
      addresses.length > 3 &&
      !showAllAddresses.value;

  Future<void> refreshAfterSave() async {
    showAllAddresses.value = true;
    await fetchAddresses();
  }

  void applyAddresses(List<UserAddress> updated) {
    _fetchVersion++;
    addresses.assignAll(updated);
    selectedIndex.value = addresses.indexWhere((a) => a.isDefault);
    showAllAddresses.value = true;
    screenState.value = LocationScreenState.success;
  }

  /// Index of the currently selected address in [addresses] (-1 = none).
  final RxInt selectedIndex = (-1).obs;

  /// Tracks which address index is being persisted via PUT (shows per-tile
  /// loading indicator and prevents double-taps).
  final RxInt savingIndex = (-1).obs;
  final RxString deletingAddressId = ''.obs;
  bool _deleteDialogOpen = false;

  /// True while a GPS fetch or navigation to the map is in progress.
  final RxBool isLoadingLocation = false.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    _selectionOnly = args is Map && args['selectionOnly'] == true;
    _returnOnSelection = args is Map && args['returnOnSelection'] == true;
    _persistDefaultOnSelection =
        !_selectionOnly ||
        (args is Map && args['persistDefaultOnSelection'] == true);
    fetchAddresses();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Data fetching ─────────────────────────────────────────────────────────

  /// Loads addresses from GET /api/auth/me and pre-selects the address that
  /// matches [selectedAddressId] returned by the profile endpoint (if any).
  Future<void> fetchAddresses() async {
    if (deletingAddressId.value.isNotEmpty) return;
    final version = ++_fetchVersion;
    screenState.value = LocationScreenState.loading;
    errorMessage.value = '';
    try {
      final repo = Get.find<ApiRepo>();

      // meProfile gives us both the addresses list AND selectedAddressId.
      final profile = await repo.meProfile();
      if (isClosed || version != _fetchVersion) return;
      final user = profile.data.user;

      addresses.assignAll(user.addresses);

      final defaultAddress = user.defaultAddress;
      selectedIndex.value = defaultAddress == null
          ? -1
          : addresses.indexWhere((a) => a.id == defaultAddress.id);

      screenState.value = LocationScreenState.success;
    } catch (e) {
      if (isClosed || version != _fetchVersion) return;
      errorMessage.value = e.toString();
      screenState.value = LocationScreenState.error;
    }
  }

  // ── Address selection (tapping a tile) ───────────────────────────────────

  /// Called when the user taps an address tile.
  /// - Optimistically updates [selectedIndex] for instant feedback.
  /// - Fires PUT /api/auth/me with the selected address payload.
  /// - On error: reverts the selection and shows a snackbar.
  Future<void> selectAddress(int index) async {
    // Ignore taps while another save is in-flight or if already selected.
    if (deletingAddressId.value.isNotEmpty ||
        savingIndex.value != -1 ||
        index < 0 ||
        index >= addresses.length) {
      return;
    }

    if (selectedIndex.value == index) {
      if (_returnOnSelection) Get.key.currentState?.pop(addresses[index]);
      return;
    }
    if (!_persistDefaultOnSelection && _selectionOnly) {
      selectedIndex.value = index;
      if (_returnOnSelection) Get.key.currentState?.pop(addresses[index]);
      return;
    }
    final selectedId = addresses[index].id;
    final previous = selectedIndex.value;
    selectedIndex.value = index; // optimistic update
    savingIndex.value = index;

    try {
      final updated = await Get.find<ApiRepo>().setDefaultAddress(selectedId);
      if (isClosed) return;
      applyAddresses(updated);
      if (_returnOnSelection) {
        final address = updated.firstWhere((item) => item.id == selectedId);
        Get.key.currentState?.pop(address);
      }
    } catch (e) {
      if (isClosed) return;
      // Revert on failure.
      selectedIndex.value = previous;
      AppSnackbar.show(
        'select_location_error_title'.tr,
        'select_location_error_select'.tr,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (!isClosed) savingIndex.value = -1;
    }
  }

  // ── Derived helpers (used by the UI) ─────────────────────────────────────

  /// Icon SVG asset path for a given address.
  String iconFor(UserAddress address) => _iconFor(address.label);

  /// Icon tint colour for a given address.
  Color iconColorFor(UserAddress address) => _iconColorFor(address.label);

  // ── Quick-action stubs (navigation wired separately) ─────────────────────

  void onSearchChanged(String value) => searchQuery.value = value;

  void onUseCurrentLocation() async {
    // Request permission via shared helper (handles GPS-off + deniedForever dialogs).
    final result = await LocationPermissionHelper.request();
    if (result != LocationPermissionResult.granted) return;

    isLoadingLocation.value = true;
    try {
      final position = await LocationPermissionHelper.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      // Open the map picker centred on the user's GPS position.
      final selection = await Get.toNamed(
        AppRoutes.mapPickerScreen,
        arguments: {'initialLatLng': latLng, 'returnSelection': _selectionOnly},
      );
      if (isClosed) return;
      if (_selectionOnly && selection is Map<String, dynamic>) {
        final address = await Get.toNamed(
          AppRoutes.addressFormScreen,
          arguments: {...selection, 'checkoutMode': true},
        );
        if (!isClosed && address is UserAddress) {
          Get.back(result: address);
          return;
        }
      }
      // fetchAddresses() is called by AddressFormController on save, but we
      // also refresh here in case the user went back without saving.
      await fetchAddresses();
    } catch (e) {
      AppSnackbar.show(
        'select_location_error_title'.tr,
        e.toString(),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Opens MapPickerScreen in "add new" mode (no pre-filled data).
  Future<void> onAddNewAddress() async {
    final result = await Get.toNamed(
      AppRoutes.addressFormScreen,
      arguments: {'checkoutMode': _selectionOnly},
    );
    if (!isClosed && _selectionOnly && result is UserAddress) {
      Get.back(result: result);
      return;
    }
    // Refresh list when user returns (whether they saved or cancelled).
    await fetchAddresses();
  }

  void onRequestFromFriend() {
    // TODO: share-link / deep-link flow
  }

  /// Opens MapPickerScreen pre-filled with the existing address at [index].
  Future<void> onEditAddress(int index) async {
    if (deletingAddressId.value.isNotEmpty ||
        index < 0 ||
        index >= addresses.length) {
      return;
    }
    final address = addresses[index];
    final detailPrefix = [
      address.house,
      address.building,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
    final mapAddress =
        detailPrefix.isNotEmpty &&
            address.addressLine.startsWith('$detailPrefix, ')
        ? address.addressLine.substring(detailPrefix.length + 2)
        : address.addressLine;
    await Get.toNamed(
      AppRoutes.addressFormScreen,
      arguments: {
        'addressId': address.id,
        'isDefault': address.isDefault,
        'house': address.house ?? '',
        'building': address.building ?? '',
        'addressLine': mapAddress,
        'addressType': address.addressType,
        'label': address.label,
        'name': address.name,
        'city': address.city,
        'state': address.state,
        'zipcode': address.zipcode,
        'display': address.area ?? address.addressLine,
        if (address.latitude != null && address.longitude != null)
          'latLng': LatLng(address.latitude!, address.longitude!),
        'displayAddress': address.displayAddress,
      },
    );
    await fetchAddresses();
  }

  Future<void> onDeleteAddress(int index) async {
    if (_deleteDialogOpen ||
        deletingAddressId.value.isNotEmpty ||
        savingIndex.value != -1 ||
        index < 0 ||
        index >= addresses.length) {
      return;
    }
    final address = addresses[index];
    if (address.id.trim().isEmpty) return;
    _deleteDialogOpen = true;
    bool confirmed;
    try {
      confirmed =
          await Get.dialog<bool>(
            AlertDialog(
              title: Center(child: Text("Delete address?".tr)),
              content: Text(
                textAlign: TextAlign.center,
                "Are you sure you want to delete this address?".tr,
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.key.currentState?.pop(false),
                  child: Text("Cancel".tr),
                ),
                TextButton(
                  onPressed: () => Get.key.currentState?.pop(true),
                  child: Text("OK".tr),
                ),
              ],
            ),
          ) ??
          false;
    } finally {
      _deleteDialogOpen = false;
    }
    if (!confirmed || isClosed) return;
    deletingAddressId.value = address.id;
    // Do not let an earlier profile response restore the deleted row.
    _fetchVersion++;
    try {
      await Get.find<ApiRepo>().removeAddress(address.id);
      if (isClosed) return;
      final selectedId =
          selectedIndex.value >= 0 && selectedIndex.value < addresses.length
          ? addresses[selectedIndex.value].id
          : null;
      addresses.removeWhere((item) => item.id == address.id);
      selectedIndex.value = selectedId == null
          ? -1
          : addresses.indexWhere((item) => item.id == selectedId);
      screenState.value = LocationScreenState.success;
    } catch (_) {
      if (!isClosed) {
        screenState.value = LocationScreenState.success;
        AppSnackbar.show(
          "Could not delete address".tr,
          "Please try again. Your address has not been removed.".tr,
        );
      }
    } finally {
      if (!isClosed) deletingAddressId.value = '';
    }
  }

  void onShareAddress(int index) {
    // TODO: share address text
  }

  void onViewAll() {
    if (canViewAll) showAllAddresses.value = true;
  }

  void onConfirmLocation() {
    if (deletingAddressId.value.isNotEmpty || savingIndex.value != -1) return;
    if (selectedIndex.value == -1) {
      AppSnackbar.show(
        'select_location_error_title'.tr,
        'select_location_error_none'.tr,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    Get.back(result: addresses[selectedIndex.value]);
  }
}
