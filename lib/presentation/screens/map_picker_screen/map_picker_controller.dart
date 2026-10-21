import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide Response;
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/helpers/location_permission_helper.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

/// A single autocomplete prediction returned by the Google Places API.
class PlacePrediction {
  final String placeId;
  final String mainText; // e.g. "Sector 22"
  final String secondaryText; // e.g. "Chandigarh, India"

  const PlacePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    this.description = '',
  });

  final String description;
  String get fullText => description.isNotEmpty
      ? description
      : secondaryText.isEmpty
      ? mainText
      : '$mainText, $secondaryText';
}

class _PlacesApiException implements Exception {
  final String message;

  const _PlacesApiException(this.message);
}

// ─── Reverse-geocode result ───────────────────────────────────────────────────

class ReverseGeocodeResult {
  final String addressLine;
  final String city;
  final String state;
  final String zipcode;
  final String display; // one-line summary shown in the bottom card

  const ReverseGeocodeResult({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.display,
  });

  static const ReverseGeocodeResult empty = ReverseGeocodeResult(
    addressLine: '',
    city: '',
    state: '',
    zipcode: '',
    display: '',
  );
}

// ─── Controller ───────────────────────────────────────────────────────────────

/// Drives [MapPickerScreen].
///
/// Responsibilities:
/// - Initialises camera to GPS position (if permission already granted) or
///   to the [initialLatLng] argument passed from the previous screen.
/// - Tracks the map-center [LatLng] as the user drags.
/// - On [onCameraIdle], debounces 600 ms then reverse-geocodes the center.
/// - Exposes a Google Places autocomplete search: debounces 300 ms, fetches
///   predictions, lets user pick one and animates camera to it.
/// - "Use current location" FAB delegates to [LocationPermissionHelper].
class MapPickerController extends GetxController {
  // ── Constants ─────────────────────────────────────────────────────────────
  static const LatLng _indiaCenter = LatLng(20.5937, 78.9629);
  static const double _defaultZoom = 5.0;
  static const double _streetZoom = 19.0;

  MapPickerController({Dio? placesClient, this.reverseGeocoder})
    : _dio =
          placesClient ??
          Dio(BaseOptions(connectTimeout: const Duration(seconds: 10))),
      _ownsDio = placesClient == null;

  final Future<List<Placemark>> Function(double, double)? reverseGeocoder;
  final bool _ownsDio;
  String? _sessionToken;
  bool _detailsPending = false;
  bool _queryUnresolved = false;
  final locationPermissionGranted = false.obs;
  LatLng? _committedCenter;
  ReverseGeocodeResult _committedResult = ReverseGeocodeResult.empty;
  final searchError = false.obs;

  Future<Response<dynamic>> _placesRequest(
    String endpoint,
    Map<String, dynamic> data,
    CancelToken? cancelToken,
  ) async {
    final token = Get.isRegistered<AuthSession>()
        ? Get.find<AuthSession>().accessToken
        : await const FlutterSecureStorage().read(key: 'auth_token');
    return _dio.post(
      '${ApiEndpoints.apiBaseUrl.replaceFirst(RegExp(r"/+$"), "")}/places/$endpoint',
      data: data,
      cancelToken: cancelToken,
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        contentType: Headers.jsonContentType,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  void retrySearch() => onSearchChanged(searchText.value);

  // ── Map ───────────────────────────────────────────────────────────────────
  GoogleMapController? _mapController;
  final RxBool isMapReady = false.obs;

  /// The LatLng that is currently at the center of the viewport (= pin tip).
  final Rx<LatLng> centerLatLng = _indiaCenter.obs;

  // ── Location ──────────────────────────────────────────────────────────────
  final RxBool isLocating = false.obs;

  // ── Reverse geocode ───────────────────────────────────────────────────────
  final Rx<ReverseGeocodeResult> geocodeResult = ReverseGeocodeResult.empty.obs;
  final RxBool isGeocoding = false.obs;
  Timer? _geocodeDebounce;
  int _geocodeVersion = 0;
  LatLng? _resolvedPlaceCenter;
  ReverseGeocodeResult? _resolvedPlaceResult;
  LatLng? _programmaticCameraTarget;
  bool _returnSelection = false;
  bool _addressOnboarding = false;
  bool _confirming = false;
  final geocodeError = ''.obs;
  int _searchVersion = 0;
  bool get canConfirm =>
      geocodeError.value.isEmpty &&
      !_confirming &&
      !isGeocoding.value &&
      !isLocating.value &&
      !isSearching.value &&
      geocodeResult.value.display.isNotEmpty;
  void retryGeocode() => _reverseGeocode(centerLatLng.value);

  // ── Places autocomplete ───────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();

  /// Mirrors [searchController.text] as an observable so the UI can reactively
  /// show/hide the clear (✕) button without a ValueListenableBuilder.
  final RxString searchText = ''.obs;
  final RxList<PlacePrediction> predictions = <PlacePrediction>[].obs;
  final RxBool isSearching = false.obs;
  final RxBool showDropdown = false.obs;
  final RxString searchMessage = ''.obs;
  Timer? _searchDebounce;
  CancelToken? _searchCancelToken;
  final Dio _dio;

  // ── Edit mode (prefilled when editing an existing address) ────────────────
  /// When non-null, the form will be pre-populated with this address.
  final RxString editAddressId = ''.obs;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _applyArguments();
  }

  @override
  void onClose() {
    _geocodeDebounce?.cancel();
    _searchDebounce?.cancel();
    _searchCancelToken?.cancel();
    _geocodeVersion++;
    _searchVersion++;
    _sessionToken = null;
    _mapController?.dispose();
    searchController.dispose();
    if (_ownsDio) _dio.close();
    super.onClose();
  }

  // ── Argument handling ─────────────────────────────────────────────────────

  void _applyArguments() {
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      _initFromGps();
      return;
    }

    // If an existing address is passed for editing, store the id and
    // pre-center the map on the provided LatLng.
    _returnSelection = args['returnSelection'] == true;
    _addressOnboarding = args['addressOnboarding'] == true;
    editAddressId.value = args['addressId'] as String? ?? '';
    final initial = args['initialLatLng'] as LatLng?;
    if (initial != null) {
      centerLatLng.value = initial;
      // Camera will be set after onMapCreated fires.
    } else if (!_returnSelection) {
      _initFromGps();
    }

    // Pre-fill search bar with existing address text if provided.
    final existingDisplay = args['displayAddress'] as String?;
    if (existingDisplay != null && existingDisplay.isNotEmpty) {
      searchController.text = existingDisplay;
      searchText.value = existingDisplay;
    }
  }

  Future<void> _initFromGps() async {
    final version = _searchVersion;
    final granted = await LocationPermissionHelper.isGranted();
    if (isClosed) return;
    locationPermissionGranted.value = granted;
    if (granted && version == _searchVersion) {
      await _fetchAndMoveToCurrent();
    }
    // If not granted, the map opens at _indiaCenter (India overview).
  }

  // ── Map callbacks ─────────────────────────────────────────────────────────

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    isMapReady.value = true;
    unawaited(_checkLocationPermission());
    // Animate to the target LatLng now that the controller is ready.
    unawaited(
      _animateTo(centerLatLng.value, zoom: initialCameraZoom).catchError((_) {
        if (!isClosed) {
          geocodeError.value = "Could not move the map. Please try again.".tr;
        }
      }),
    );
    onCameraIdle();
  }

  Future<void> _checkLocationPermission() async {
    final granted = await LocationPermissionHelper.isGranted();
    if (!isClosed) locationPermissionGranted.value = granted;
  }

  void _rememberCommittedAddress() {
    if (geocodeResult.value.display.isNotEmpty && geocodeError.value.isEmpty) {
      _committedCenter = centerLatLng.value;
      _committedResult = geocodeResult.value;
    }
  }

  /// Fires continuously while the user is dragging; just track the center.
  void onCameraMove(CameraPosition position) {
    _rememberCommittedAddress();
    if (_programmaticCameraTarget == null) {
      _queryUnresolved = false;
      _searchCancelToken?.cancel();
      _searchVersion++;
      _searchDebounce?.cancel();
      _detailsPending = false;
      isSearching.value = false;
      showDropdown.value = false;
      _sessionToken = null;
    }
    geocodeError.value = '';
    _geocodeVersion++;
    isGeocoding.value = true;
    centerLatLng.value = position.target;
    if (_programmaticCameraTarget == null) {
      _resolvedPlaceCenter = null;
      _resolvedPlaceResult = null;
    }
    // Cancel any pending reverse-geocode while the user is still dragging.
    _geocodeDebounce?.cancel();
    geocodeResult.value = ReverseGeocodeResult.empty;
  }

  /// Fires when the camera stops.  Triggers a debounced reverse-geocode.
  void onCameraIdle() {
    _geocodeDebounce?.cancel();
    if (_queryUnresolved) return;
    final resolvedCenter = _resolvedPlaceCenter;
    final resolvedResult = _resolvedPlaceResult;
    if (resolvedCenter != null &&
        resolvedResult != null &&
        _isSameLocation(centerLatLng.value, resolvedCenter)) {
      _geocodeVersion++;
      geocodeError.value = '';
      geocodeResult.value = resolvedResult;
      _committedCenter = resolvedCenter;
      _committedResult = resolvedResult;
      isGeocoding.value = false;
      _programmaticCameraTarget = null;
      return;
    }
    if (_programmaticCameraTarget != null) {
      _resolvedPlaceCenter = null;
      _resolvedPlaceResult = null;
      _programmaticCameraTarget = null;
    }
    _geocodeDebounce = Timer(
      const Duration(milliseconds: 600),
      () => _reverseGeocode(centerLatLng.value),
    );
  }

  void zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  // ── Current location FAB ──────────────────────────────────────────────────

  Future<void> onUseCurrentLocation() async {
    if (isLocating.value) return;
    isLocating.value = true;
    try {
      final result = await LocationPermissionHelper.request();
      if (isClosed || result != LocationPermissionResult.granted) return;
      locationPermissionGranted.value = true;
      await _fetchAndMoveToCurrent();
    } finally {
      if (!isClosed) isLocating.value = false;
    }
  }

  Future<void> _fetchAndMoveToCurrent() async {
    isLocating.value = true;
    clearSearch();
    final version = _searchVersion;
    try {
      final pos = await LocationPermissionHelper.getCurrentPosition();
      if (isClosed || version != _searchVersion) return;
      final latLng = LatLng(pos.latitude, pos.longitude);
      await _moveToLocation(latLng);
    } catch (e) {
      AppSnackbar.show(
        "Location Error".tr,
        e.toString(),
        margin: const EdgeInsets.all(16),
      );
    } finally {
      if (!isClosed) isLocating.value = false;
    }
  }

  // ── Places autocomplete ───────────────────────────────────────────────────

  void onSearchChanged(String query) {
    _queryUnresolved = true;
    _rememberCommittedAddress();
    if (_detailsPending) _sessionToken = null;
    _detailsPending = false;
    searchText.value = query;
    _searchDebounce?.cancel();
    _searchCancelToken?.cancel();
    _searchVersion++;
    isSearching.value = false;
    predictions.clear();
    searchMessage.value = '';
    showDropdown.value = false;
    searchError.value = false;
    _geocodeDebounce?.cancel();
    _geocodeVersion++;
    _resolvedPlaceCenter = null;
    _resolvedPlaceResult = null;
    geocodeResult.value = ReverseGeocodeResult.empty;
    geocodeError.value = '';
    isGeocoding.value = false;
    final input = query.trim();
    if (input.length < 3) {
      _sessionToken = null;
      return;
    }
    _searchDebounce = Timer(
      const Duration(milliseconds: 300),
      () => _fetchPredictions(input),
    );
  }

  Future<void> _fetchPredictions(String input) async {
    _searchCancelToken?.cancel();
    final version = ++_searchVersion;
    _searchCancelToken = CancelToken();
    isSearching.value = true;
    showDropdown.value = true;
    searchMessage.value = 'Searching places…';
    try {
      final response = await _placesRequest('autocomplete', {
        'input': input,
        'sessionToken': _sessionToken ??= const Uuid().v4(),
      }, _searchCancelToken);
      if (isClosed || version != _searchVersion) return;
      final json = _asJsonMap(response.data);
      if (json['success'] != true) {
        throw const _PlacesApiException(
          'Address search is temporarily unavailable. Please retry.',
        );
      }
      final data = _asJsonMap(json['data']);
      final list = data['suggestions'] ?? [];
      if (list is! List) throw FormatException("Invalid suggestions".tr);
      final results = <PlacePrediction>[];
      for (final item in list) {
        if (item is! Map) continue;
        final placeId = item['placeId'];
        final description = item['description'];
        if (placeId is! String || placeId.isEmpty) continue;
        final mainText = item['mainText'] as String? ?? '';
        final secondaryText = item['secondaryText'] as String? ?? '';
        final displayText = mainText.isNotEmpty
            ? mainText
            : description as String? ?? '';
        if (displayText.isEmpty) continue;
        results.add(
          PlacePrediction(
            placeId: placeId,
            mainText: displayText,
            secondaryText: secondaryText,
            description: description is String ? description : '',
          ),
        );
      }
      predictions.assignAll(results);
      if (results.isEmpty) {
        searchMessage.value = 'No places found. Try a different search.';
      }
      showDropdown.value = true;
    } on DioException catch (e) {
      if (isClosed ||
          version != _searchVersion ||
          e.type == DioExceptionType.cancel) {
        return;
      }
      predictions.clear();
      searchError.value = true;
      searchMessage.value = _requestErrorMessage(e);
      showDropdown.value = true;
    } catch (e) {
      if (isClosed || version != _searchVersion) return;
      predictions.clear();
      searchError.value = true;
      searchMessage.value = e is _PlacesApiException
          ? e.message
          : 'Could not read place search results. Try again.';
      showDropdown.value = true;
    } finally {
      if (!isClosed && version == _searchVersion) {
        isSearching.value = false;
      }
    }
  }

  /// Called when the user taps a prediction row.
  Future<void> onPredictionSelected(PlacePrediction prediction) async {
    if (isSearching.value || prediction.placeId.isEmpty) return;
    _searchDebounce?.cancel();
    _searchCancelToken?.cancel();
    final version = ++_searchVersion;
    final cancelToken = CancelToken();
    _searchCancelToken = cancelToken;
    // Dismiss dropdown immediately.
    showDropdown.value = false;
    predictions.clear();
    searchController.text = prediction.fullText;
    searchText.value = prediction.fullText;
    searchMessage.value = '';
    FocusManager.instance.primaryFocus?.unfocus();

    isSearching.value = true;
    _detailsPending = true;
    try {
      final response = await _placesRequest('details', {
        'placeId': prediction.placeId,
        'sessionToken': _sessionToken ??= const Uuid().v4(),
      }, cancelToken);
      if (isClosed || version != _searchVersion) return;
      final json = _asJsonMap(response.data);
      if (json['success'] != true) {
        throw const _PlacesApiException(
          'Could not load this place. Please search again.',
        );
      }
      final result = _asJsonMap(json['data']);
      if (result['lat'] is! num || result['lng'] is! num) {
        throw FormatException("Missing place coordinates".tr);
      }
      final lat = (result['lat'] as num).toDouble();
      final lng = (result['lng'] as num).toDouble();
      if (!lat.isFinite ||
          !lng.isFinite ||
          lat < -90 ||
          lat > 90 ||
          lng < -180 ||
          lng > 180) {
        throw FormatException("Invalid place coordinates".tr);
      }
      final placeResult = _placeAddressResult(result, prediction.fullText);
      _queryUnresolved = false;
      await _moveToLocation(
        LatLng(lat, lng),
        version: version,
        resolvedResult: placeResult,
      );
    } on DioException catch (e) {
      if (isClosed ||
          version != _searchVersion ||
          e.type == DioExceptionType.cancel) {
        return;
      }
      _showDetailsError(_requestErrorMessage(e));
    } catch (e) {
      if (isClosed || version != _searchVersion) return;
      _showDetailsError(
        e is _PlacesApiException
            ? e.message
            : 'Could not load this place. Retry or enter the address manually.',
      );
    } finally {
      if (version == _searchVersion) {
        _sessionToken = null;
        _detailsPending = false;
      }
      if (!isClosed && version == _searchVersion) isSearching.value = false;
    }
  }

  String _requestErrorMessage(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Address search timed out. Please retry.';
    }
    return switch (error.response?.statusCode) {
      401 => 'Your session has expired. Sign in again to search.',
      429 => 'Address search is busy. Please wait and retry.',
      503 => 'Address search is temporarily unavailable. Please retry later.',
      400 => 'This search could not be processed. Try another address.',
      _ => 'Could not search places. Check your connection and try again.',
    };
  }

  void _showDetailsError(String message) {
    searchMessage.value = message;
    searchError.value = true;
    showDropdown.value = true;
  }

  Future<void> restorePreviousLocation() async {
    final center = _committedCenter;
    if (center == null) return;
    clearSearch();
    await _moveToLocation(center, resolvedResult: _committedResult);
  }

  void enterAddressManually() {
    clearSearch();
    if (_returnSelection) {
      Get.back(
        result: <String, dynamic>{
          'addressLine': '',
          'city': '',
          'state': '',
          'zipcode': '',
        },
      );
    } else {
      Get.offNamed(
        AppRoutes.addressFormScreen,
        arguments: {'addressOnboarding': _addressOnboarding},
      );
    }
  }

  void clearSearch() {
    _rememberCommittedAddress();
    _queryUnresolved = true;
    _geocodeDebounce?.cancel();
    _geocodeVersion++;
    _resolvedPlaceCenter = null;
    _resolvedPlaceResult = null;
    _programmaticCameraTarget = null;
    geocodeResult.value = ReverseGeocodeResult.empty;
    geocodeError.value = '';
    isGeocoding.value = false;
    _detailsPending = false;
    _sessionToken = null;
    searchError.value = false;
    _searchDebounce?.cancel();
    _searchCancelToken?.cancel();
    _searchVersion++;
    isSearching.value = false;
    searchController.clear();
    searchText.value = '';
    predictions.clear();
    searchMessage.value = '';
    showDropdown.value = false;
  }

  Future<void> _moveToLocation(
    LatLng target, {
    int? version,
    ReverseGeocodeResult? resolvedResult,
  }) async {
    if (version != null && (isClosed || version != _searchVersion)) return;
    _queryUnresolved = false;
    _rememberCommittedAddress();
    final previousCenter = centerLatLng.value;
    final previousResult = geocodeResult.value;
    _geocodeDebounce?.cancel();
    _geocodeVersion++;
    geocodeError.value = '';
    geocodeResult.value = ReverseGeocodeResult.empty;
    isGeocoding.value = true;
    centerLatLng.value = target;
    _resolvedPlaceCenter = resolvedResult == null ? null : target;
    _resolvedPlaceResult = resolvedResult;
    _programmaticCameraTarget = target;
    try {
      await _animateTo(target, zoom: resolvedResult == null ? _streetZoom : 16);
    } catch (_) {
      if (isClosed || (version != null && version != _searchVersion)) return;
      centerLatLng.value = previousCenter;
      geocodeResult.value = previousResult;
      _resolvedPlaceCenter = null;
      _resolvedPlaceResult = null;
      _programmaticCameraTarget = null;
      isGeocoding.value = false;
      geocodeError.value = "Could not move the map. Please try again.".tr;
      rethrow;
    }
    if (isClosed || (version != null && version != _searchVersion)) return;
    // Native camera idle commits the address after animation has actually ended.
    if (_mapController == null) onCameraIdle();
  }

  ReverseGeocodeResult _placeAddressResult(
    dynamic result,
    String fallbackDisplay,
  ) {
    final data = _asJsonMap(result);
    return ReverseGeocodeResult(
      addressLine: data['addressLine'] as String? ?? '',
      city: data['city'] as String? ?? '',
      state: data['state'] as String? ?? '',
      zipcode: data['zipcode'] as String? ?? '',
      display: data['address'] as String? ?? fallbackDisplay,
    );
  }

  bool _isSameLocation(LatLng first, LatLng second) =>
      (first.latitude - second.latitude).abs() < 0.00001 &&
      (first.longitude - second.longitude).abs() < 0.00001;

  Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw FormatException("Invalid Places API response".tr);
  }

  // ── Reverse geocoding ─────────────────────────────────────────────────────

  Future<void> _reverseGeocode(LatLng latLng) async {
    final version = ++_geocodeVersion;
    geocodeError.value = '';
    isGeocoding.value = true;
    geocodeResult.value = ReverseGeocodeResult.empty;
    try {
      final lookup = reverseGeocoder ?? Geocoding().placemarkFromCoordinates;
      final placemarks = await lookup(
        latLng.latitude,
        latLng.longitude,
      ).timeout(const Duration(seconds: 15));
      if (isClosed || version != _geocodeVersion) return;
      if (placemarks.isEmpty) throw FormatException("No address found".tr);
      final p = placemarks.first;

      // Build a structured result from the placemark components.
      final addressLine = [
        p.name,
        p.subLocality,
        p.thoroughfare,
      ].where((s) => s != null && s.isNotEmpty).join(', ');

      final display = [
        p.name,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.postalCode,
        p.country,
      ].where((s) => s != null && s.isNotEmpty).join(', ');

      geocodeResult.value = ReverseGeocodeResult(
        addressLine: addressLine.isNotEmpty ? addressLine : (p.street ?? ''),
        city: p.locality ?? '',
        state: p.administrativeArea ?? '',
        zipcode: p.postalCode ?? '',
        display: display,
      );
      _committedCenter = latLng;
      _committedResult = geocodeResult.value;
    } catch (_) {
      if (isClosed || version != _geocodeVersion) return;
      geocodeResult.value = _committedResult;
      geocodeError.value =
          "Could not find an address here. Retry or enter the address manually."
              .tr;
    } finally {
      if (!isClosed && version == _geocodeVersion) isGeocoding.value = false;
    }
  }

  // ── Confirm — navigate to address form ───────────────────────────────────

  void onConfirmLocation() {
    final result = geocodeResult.value;
    if (!canConfirm) return;
    _confirming = true;
    final selection = <String, dynamic>{
      'addressOnboarding': _addressOnboarding,
      'latLng': centerLatLng.value,
      'addressLine': result.addressLine,
      'display': result.display,
      'city': result.city,
      'state': result.state,
      'zipcode': result.zipcode,
      'addressId': editAddressId.value,
    };
    if (_returnSelection) {
      Get.back(result: selection);
    } else {
      Get.offNamed(AppRoutes.addressFormScreen, arguments: selection);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _animateTo(LatLng target, {double zoom = _streetZoom}) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  LatLng get initialCameraTarget => centerLatLng.value;
  double get initialCameraZoom =>
      centerLatLng.value == _indiaCenter ? _defaultZoom : _streetZoom;
}
