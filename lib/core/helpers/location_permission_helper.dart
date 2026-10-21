import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

// ─── Result enum ──────────────────────────────────────────────────────────────

/// Typed result returned by [LocationPermissionHelper.request].
///
/// Callers switch on this to decide what to do next:
/// - [granted]         → proceed with GPS fetch
/// - [denied]          → user dismissed; show a gentle nudge if needed
/// - [deniedForever]   → can only recover via app settings (helper opens them)
/// - [serviceDisabled] → GPS radio is off; helper shows the OS location dialog
enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

// ─── Helper ───────────────────────────────────────────────────────────────────

/// A single reusable class that handles every location permission edge-case.
///
/// **Usage** — call from any controller / widget:
/// ```dart
/// final result = await LocationPermissionHelper.request(context);
/// if (result == LocationPermissionResult.granted) {
///   final pos = await Geolocator.getCurrentPosition();
///   ...
/// }
/// ```
///
/// No need to copy permission-request boilerplate into each screen; every
/// screen delegates here.
abstract final class LocationPermissionHelper {
  // ── Public API ─────────────────────────────────────────────────────────────

  /// Checks whether location services are enabled and whether the app has the
  /// required permission.  Requests permission if it has not been decided yet.
  ///
  /// Side-effects:
  /// - [serviceDisabled]  → shows a GetX dialog offering to open OS settings.
  /// - [deniedForever]    → shows a GetX dialog and calls [Geolocator.openAppSettings].
  ///
  /// Returns a [LocationPermissionResult] that the caller can act on.
  static Future<LocationPermissionResult> request() async {
    // 1. Check GPS radio ─────────────────────────────────────────────────────
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showGpsOffDialog();
      return LocationPermissionResult.serviceDisabled;
    }

    // 2. Check / request permission ──────────────────────────────────────────
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionResult.granted;

      case LocationPermission.denied:
        // User tapped "Don't allow" this time; they can be asked again.
        return LocationPermissionResult.denied;

      case LocationPermission.deniedForever:
        // User chose "Never" — the only recovery is the app settings page.
        await _showDeniedForeverDialog();
        return LocationPermissionResult.deniedForever;

      case LocationPermission.unableToDetermine:
        return LocationPermissionResult.denied;
    }
  }

  /// Convenience: returns `true` if permission is already granted without
  /// showing any dialog.  Useful for deciding whether to show the blue dot on
  /// GoogleMap (`myLocationEnabled`).
  static Future<bool> isGranted() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    final p = await Geolocator.checkPermission();
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }

  /// Fetches the current [Position].  Assumes permission is already granted.
  /// Throws a [String] message on failure so callers can forward it to the UI.
  static Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  // ── Private dialog helpers ─────────────────────────────────────────────────

  /// Shown when the device GPS radio is switched off.
  /// Offers to open the OS location settings.
  static Future<void> _showGpsOffDialog() async {
    await Get.dialog<void>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'location_gps_off_title'.tr,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: Text(
          'location_gps_off_body'.tr,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(
              'location_dialog_cancel'.tr,
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111111),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              Get.back();
              // Opens the system Location Settings page.
              await Geolocator.openLocationSettings();
            },
            child: Text(
              'location_dialog_open_settings'.tr,
              style: const TextStyle(fontFamily: 'Inter'),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Shown when the permission has been permanently denied.
  /// Directs the user to the app's permission settings.
  static Future<void> _showDeniedForeverDialog() async {
    final screenWidth = Get.width;
    final bool isSmallScreen = screenWidth < 360;

    await Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 22,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            isSmallScreen ? 18 : 22,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 16 : 20,
            isSmallScreen ? 14 : 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==========================================================
              // SMALL LOCATION ICON
              // ==========================================================

              Container(
                padding: EdgeInsets.all(
                  isSmallScreen ? 9 : 10,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_disabled_rounded,
                  size: isSmallScreen ? 20 : 22,
                  color: const Color(0xFF111111),
                ),
              ),

              SizedBox(
                height: isSmallScreen ? 10 : 12,
              ),

              // ==========================================================
              // TITLE
              // ==========================================================

              Text(
                'location_denied_forever_title'.tr,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                  height: 1.2,
                ),
              ),

              SizedBox(
                height: isSmallScreen ? 6 : 8,
              ),

              // ==========================================================
              // DESCRIPTION
              // ==========================================================

              Text(
                'location_denied_forever_body'.tr,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: isSmallScreen ? 12 : 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),

              SizedBox(
                height: isSmallScreen ? 12 : 16,
              ),

              // ==========================================================
              // STEPS TITLE
              // ==========================================================

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'location_enable_steps_title'.tr,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111111),
                  ),
                ),
              ),

              SizedBox(
                height: isSmallScreen ? 7 : 9,
              ),

              // ==========================================================
              // STEP 1
              // ==========================================================

              _locationStep(
                number: '1',
                text: 'location_enable_step_1'.tr,
                isSmallScreen: isSmallScreen,
              ),

              // ==========================================================
              // STEP 2
              // ==========================================================

              _locationStep(
                number: '2',
                text: 'location_enable_step_2'.tr,
                isSmallScreen: isSmallScreen,
              ),

              // ==========================================================
              // STEP 3
              // ==========================================================

              _locationStep(
                number: '3',
                text: 'location_enable_step_3'.tr,
                isSmallScreen: isSmallScreen,
              ),

              // ==========================================================
              // STEP 4
              // ==========================================================

              _locationStep(
                number: '4',
                text: 'location_enable_step_4'.tr,
                isSmallScreen: isSmallScreen,
              ),

              SizedBox(
                height: isSmallScreen ? 14 : 16,
              ),

              // ==========================================================
              // BUTTONS - ALWAYS ONE ROW
              // ==========================================================

              Row(
                children: [
                  Expanded(
                    child: _cancelButton(
                      isSmallScreen: isSmallScreen,
                    ),
                  ),

                  SizedBox(
                    width: isSmallScreen ? 8 : 10,
                  ),

                  Expanded(
                    child: _openSettingsButton(
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
    );
  }


  /// ----------------------------------------------------------------------
  /// Location permission step
  /// ----------------------------------------------------------------------

  static Widget _locationStep({
    required String number,
    required String text,
    required bool isSmallScreen,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isSmallScreen ? 6 : 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Number
          Container(
            padding: EdgeInsets.all(
              isSmallScreen ? 4 : 5,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSmallScreen ? 9 : 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(
            width: isSmallScreen ? 8 : 9,
          ),

          // Step text
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: isSmallScreen ? 11.5 : 12.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4B5563),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// ----------------------------------------------------------------------
  /// Cancel button
  /// ----------------------------------------------------------------------

  static Widget _cancelButton({
    required bool isSmallScreen,
  }) {
    return OutlinedButton(
      onPressed: () {
        Get.back();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111111),
        backgroundColor: Colors.white,
        side: const BorderSide(
          color: Color(0xFFD1D5DB),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 11 : 12,
          horizontal: 8,
        ),
      ),
      child: Text(
        'location_dialog_cancel'.tr,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isSmallScreen ? 11.5 : 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  /// ----------------------------------------------------------------------
  /// Open App Settings button
  /// ----------------------------------------------------------------------

  static Widget _openSettingsButton({
    required bool isSmallScreen,
  }) {
    return ElevatedButton(
      onPressed: () async {
        Get.back();

        await Geolocator.openAppSettings();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 11 : 12,
          horizontal: 8,
        ),
      ),
      child: Text(
        'location_dialog_open_app_settings'.tr,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: isSmallScreen ? 11.5 : 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

}
