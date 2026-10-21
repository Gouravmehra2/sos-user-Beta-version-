import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/core/helpers/location_permission_helper.dart';

class MapController extends GetxController {
  // ── Map controller ────────────────────────────────────────────────────────
  GoogleMapController? mapController;

  // ── State ─────────────────────────────────────────────────────────────────
  final Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  final Rx<LatLng?> selectedPosition = Rx<LatLng?>(null);
  final RxBool isLoadingLocation = false.obs;
  final RxBool isMapReady = false.obs;
  final RxBool locationPermissionGranted = false.obs;
  final RxString selectedAddress = ''.obs;

  static const LatLng _defaultPosition = LatLng(20.5937, 78.9629);
  static const double _defaultZoom = 5.0;
  static const double _locationZoom = 19.0;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Silently checks permission on launch (no dialog) so we can set
  /// [locationPermissionGranted] for the GoogleMap widget, then fetches the
  /// current position if already granted.
  Future<void> _initLocation() async {
    final already = await LocationPermissionHelper.isGranted();
    locationPermissionGranted.value = already;
    if (already) {
      await _fetchCurrentLocation();
    }
  }

  // ── Map callbacks ─────────────────────────────────────────────────────────

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady.value = true;
    _animateTo(initialCameraTarget, zoom: initialZoom);
  }

  void onCameraIdle() {
    // Wire reverse-geocoding here when needed.
  }

  void onTap(LatLng position) {
    selectedPosition.value = position;
    update();
  }

  // ── Public: "Use my location" button ─────────────────────────────────────

  /// Called by the FAB.  Delegates all permission edge-cases to
  /// [LocationPermissionHelper] — the controller stays clean.
  Future<void> goToCurrentLocation() async {
    final result = await LocationPermissionHelper.request();
    if (result != LocationPermissionResult.granted) return;

    locationPermissionGranted.value = true;
    await _fetchCurrentLocation(animateCamera: true);
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  Future<void> _fetchCurrentLocation({bool animateCamera = false}) async {
    isLoadingLocation.value = true;
    try {
      final position = await LocationPermissionHelper.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = latLng;
      selectedPosition.value = latLng;
      if (animateCamera || isMapReady.value) {
        _animateTo(latLng, zoom: _locationZoom);
      }
      update();
    } catch (e) {
      AppSnackbar.show(
        "Location Error".tr,
        e.toString(),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // ── Confirm ───────────────────────────────────────────────────────────────

  void confirmLocation() {
    final pos = selectedPosition.value;
    if (pos == null) {
      AppSnackbar.show(
        "No Location".tr,
        "Please select a location on the map.".tr,
        margin: const EdgeInsets.all(16),
      );
      return;
    }
    Get.back(result: pos);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  LatLng get initialCameraTarget => currentPosition.value ?? _defaultPosition;
  double get initialZoom =>
      currentPosition.value != null ? _locationZoom : _defaultZoom;

  Set<Marker> get markers {
    final pos = selectedPosition.value;
    if (pos == null) return {};
    return {
      Marker(
        markerId: const MarkerId('selected'),
        position: pos,
        infoWindow: InfoWindow(title: "map_selected_location_label".tr),
      ),
    };
  }

  void _animateTo(LatLng target, {double zoom = _locationZoom}) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }
}
