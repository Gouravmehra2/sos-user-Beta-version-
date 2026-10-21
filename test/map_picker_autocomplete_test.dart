import 'dart:convert';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/presentation/screens/map_picker_screen/map_picker_controller.dart';

class PlacesAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode({
        'success': true,
        'data': options.path.endsWith('autocomplete')
            ? {
                'suggestions': [
                  {
                    'placeId': 'one',
                    'mainText': 'Main Street',
                    'secondaryText': 'City',
                  },
                  {'mainText': 'Invalid'},
                ],
              }
            : {
                'address': 'Main Street, City',
                'addressLine': 'Main Street',
                'city': 'City',
                'lat': 0,
                'lng': 0,
              },
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class ControlledAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  final replies = <Completer<ResponseBody>>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? stream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    final reply = Completer<ResponseBody>();
    replies.add(reply);
    return reply.future;
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody reply(Map<String, dynamic> data, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(data),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Future<void> waitUntil(bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(seconds: 3));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out waiting for request state');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => Get.reset());

  test(
    'authenticated search shares token with details and clears missing fields',
    () async {
      Get.put(AuthSession()..accessToken = 'login-token');
      Get.routing.args = {'initialLatLng': const LatLng(30, 76)};
      final adapter = PlacesAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final controller = MapPickerController(placesClient: dio)..onInit();
      addTearDown(() {
        controller.onClose();
        dio.close();
      });
      controller.onSearchChanged('Ma');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(adapter.requests, isEmpty);
      controller.onSearchChanged('Main');
      controller.onSearchChanged('Main Street');
      await Future<void>.delayed(const Duration(milliseconds: 400));
      await waitUntil(
        () =>
            !controller.isSearching.value && controller.predictions.isNotEmpty,
      );
      expect(controller.predictions, hasLength(1));
      await waitUntil(
        () =>
            !controller.isSearching.value && controller.predictions.isNotEmpty,
      );
      await controller.onPredictionSelected(controller.predictions.single);
      expect(adapter.requests, hasLength(2));
      expect(adapter.requests.first.method, 'POST');
      expect(
        adapter.requests.first.headers['Authorization'],
        'Bearer login-token',
      );
      final token = adapter.requests.first.data['sessionToken'];
      expect(token, isNotEmpty);
      expect(adapter.requests.last.data['sessionToken'], token);
      expect(controller.centerLatLng.value, const LatLng(0, 0));
      expect(controller.geocodeResult.value.zipcode, isEmpty);
      expect(controller.canConfirm, isTrue);
      controller.onSearchChanged('Another place');
      expect(controller.canConfirm, isFalse);
      controller.clearSearch();
      await Future<void>.delayed(const Duration(milliseconds: 350));
      expect(adapter.requests, hasLength(2));
      expect(controller.showDropdown.value, isFalse);
    },
  );
  test(
    'late suggestions and details cannot replace a newer query; abandoned details rotate tokens',
    () async {
      Get.put(AuthSession()..accessToken = 'token');
      Get.routing.args = {'initialLatLng': const LatLng(30, 76)};
      final adapter = ControlledAdapter();
      final dio = Dio()..httpClientAdapter = adapter;
      final controller = MapPickerController(placesClient: dio)..onInit();
      addTearDown(() {
        controller.onClose();
        dio.close();
      });
      controller.onSearchChanged('Old Street');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      controller.onSearchChanged('新しい道');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await waitUntil(() => adapter.replies.length >= 2);
      adapter.replies[1].complete(
        reply({
          'success': true,
          'data': {
            'suggestions': [
              {'placeId': 'new', 'mainText': '新しい道', 'description': '新しい道、東京'},
            ],
          },
        }),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      adapter.replies[0].complete(
        reply({
          'success': true,
          'data': {
            'suggestions': [
              {'placeId': 'old', 'mainText': 'Old Street'},
            ],
          },
        }),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await waitUntil(
        () =>
            !controller.isSearching.value && controller.predictions.isNotEmpty,
      );
      expect(controller.predictions.single.placeId, 'new');
      final selection = controller.onPredictionSelected(
        controller.predictions.single,
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await waitUntil(() => adapter.replies.length >= 3);
      final oldToken = adapter.requests.last.data['sessionToken'];
      controller.onSearchChanged('Another Street');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await waitUntil(() => adapter.replies.length >= 4);
      expect(adapter.requests.last.data['sessionToken'], isNot(oldToken));
      adapter.replies[2].complete(
        reply({
          'success': true,
          'data': {'address': 'Stale location', 'lat': 1, 'lng': 2},
        }),
      );
      await selection;
      expect(controller.centerLatLng.value, const LatLng(30, 76));
      expect(controller.canConfirm, isFalse);
      controller.clearSearch();
      adapter.replies[3].complete(
        reply({
          'success': true,
          'data': {'suggestions': []},
        }),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.showDropdown.value, isFalse);
    },
  );

  test(
    'failed reverse geocoding preserves the committed address and supports restoring it',
    () async {
      Get.put(AuthSession()..accessToken = 'token');
      Get.routing.args = {'initialLatLng': const LatLng(30, 76)};
      final dio = Dio()..httpClientAdapter = PlacesAdapter();
      final controller = MapPickerController(
        placesClient: dio,
        reverseGeocoder: (_, _) =>
            Future<List<Placemark>>.error(Exception('offline')),
      )..onInit();
      addTearDown(() {
        controller.onClose();
        dio.close();
      });
      controller.onSearchChanged('Main Street');
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await waitUntil(
        () =>
            !controller.isSearching.value && controller.predictions.isNotEmpty,
      );
      await controller.onPredictionSelected(controller.predictions.single);
      controller.onCameraMove(
        const CameraPosition(target: LatLng(1, 2), zoom: 16),
      );
      controller.onCameraIdle();
      await Future<void>.delayed(const Duration(milliseconds: 650));
      expect(controller.geocodeResult.value.addressLine, 'Main Street');
      expect(controller.geocodeError.value, isNotEmpty);
      expect(controller.canConfirm, isFalse);
      await controller.restorePreviousLocation();
      expect(controller.centerLatLng.value, const LatLng(0, 0));
      expect(controller.canConfirm, isTrue);
    },
  );

  test('rate limits display a controlled retry state', () async {
    Get.put(AuthSession()..accessToken = 'token');
    Get.routing.args = {'initialLatLng': const LatLng(30, 76)};
    final adapter = ControlledAdapter();
    final dio = Dio()..httpClientAdapter = adapter;
    final controller = MapPickerController(placesClient: dio)..onInit();
    addTearDown(() {
      controller.onClose();
      dio.close();
    });
    controller.onSearchChanged('Main Street');
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await waitUntil(() => adapter.replies.isNotEmpty);
    adapter.replies.single.complete(reply({'success': false}, status: 429));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await waitUntil(() => !controller.isSearching.value);
    expect(controller.searchError.value, isTrue);
    expect(controller.searchMessage.value, contains('wait and retry'));
    expect(controller.isSearching.value, isFalse);
  });
}
