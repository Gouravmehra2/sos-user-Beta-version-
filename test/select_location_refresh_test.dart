import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:get/get.dart' hide Response;
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_controller.dart';

class _Repo implements ApiRepo {
  final removedIds = <String>[];
  late Completer<void> deletion;
  @override
  Future<void> removeAddress(String addressId) {
    deletion = Completer<void>();
    removedIds.add(addressId);
    return deletion.future;
  }

  final defaultIds = <String>[];
  late Completer<List<UserAddress>> defaultUpdate;
  @override
  Future<List<UserAddress>> setDefaultAddress(String id) {
    defaultIds.add(id);
    defaultUpdate = Completer<List<UserAddress>>();
    return defaultUpdate.future;
  }

  final requests = <Completer<HomeProfileResponse>>[];
  @override
  Future<HomeProfileResponse> meProfile() {
    final request = Completer<HomeProfileResponse>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RecordingClient implements DioClient {
  String? path;
  dynamic payload;
  @override
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    this.path = path;
    payload = data;
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: 200,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

HomeProfileResponse profile(int count, {String prefix = 'Address'}) =>
    HomeProfileResponse(
      success: true,
      data: HomeProfileData(
        user: HomeProfileUser(
          addresses: List.generate(
            count,
            (i) => UserAddress(
              id: '$i',
              label: '$prefix $i',
              addressLine: 'Road',
              city: 'City',
              state: 'State',
              zipcode: '123456',
            ),
          ),
        ),
      ),
    );

void main() {
  late _Repo repo;
  late SelectLocationController controller;
  setUp(() {
    Get.testMode = true;
    repo = _Repo();
    Get.put<ApiRepo>(repo);
    controller = SelectLocationController();
  });
  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  test('delete uses PUT auth/me with removeAddress payload', () async {
    final client = _RecordingClient();
    await ApiRepo(client).removeAddress('saved-id');
    expect(client.path, '/api/auth/me');
    expect(client.payload, {'removeAddress': 'saved-id'});
  });

  testWidgets(
    'failed checkout default update restores selection and blocks repeated requests',
    (tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
      Get.routing.args = {
        'selectionOnly': true,
        'persistDefaultOnSelection': true,
      };
      controller.onInit();
      repo.requests.last.complete(profile(2));
      await tester.pump();
      expect(controller.selectedIndex.value, 0);
      final save = controller.selectAddress(1);
      await controller.selectAddress(1);
      expect(repo.defaultIds, ['1']);
      expect(controller.savingIndex.value, 1);
      repo.defaultUpdate.completeError(Exception('offline'));
      await save;
      expect(controller.selectedIndex.value, 0);
      expect(controller.savingIndex.value, -1);
      expect(controller.addresses, hasLength(2));
      await tester.pump();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
  );

  testWidgets('cancel does not delete; OK removes row after API success', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    controller.addresses.assignAll(profile(4).data.user.addresses);
    controller.screenState.value = LocationScreenState.success;
    controller.selectedIndex.value = 2;
    final cancel = controller.onDeleteAddress(0);
    await tester.pumpAndSettle();
    expect(repo.removedIds, isEmpty);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    await tester.pump();
    await cancel;
    expect(controller.addresses.length, 4);
    expect(repo.removedIds, isEmpty);

    final deletion = controller.onDeleteAddress(0);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(repo.removedIds, ['0']);
    expect(controller.addresses.length, 4);
    await controller.onDeleteAddress(0);
    expect(repo.removedIds, ['0']);
    repo.deletion.complete();
    await tester.pump();
    await deletion;
    await tester.pumpAndSettle();
    expect(controller.addresses.map((a) => a.id), ['1', '2', '3']);
    expect(controller.selectedIndex.value, 1);
    expect(controller.canViewAll, isFalse);
  });

  testWidgets('failed deletion preserves address and selection', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    controller.addresses.assignAll(profile(1).data.user.addresses);
    controller.selectedIndex.value = 0;
    final deletion = controller.onDeleteAddress(0);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    repo.deletion.completeError(Exception('offline'));
    await tester.pump();
    await deletion;
    await tester.pumpAndSettle();
    expect(controller.addresses.length, 1);
    expect(controller.selectedIndex.value, 0);
    expect(controller.deletingAddressId.value, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('deleting last selected address clears selection', (
    tester,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: Scaffold()));
    controller.addresses.assignAll(profile(1).data.user.addresses);
    controller.selectedIndex.value = 0;
    final deletion = controller.onDeleteAddress(0);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    repo.deletion.complete();
    await tester.pump();
    await deletion;
    expect(controller.addresses, isEmpty);
    expect(controller.selectedIndex.value, -1);
    expect(controller.screenState.value, LocationScreenState.success);
  });

  test(
    'View All is hidden through three addresses and expands larger lists',
    () async {
      for (var count = 0; count <= 4; count++) {
        final fetch = controller.fetchAddresses();
        repo.requests.last.complete(profile(count));
        await fetch;
        expect(controller.visibleAddressCount, count > 3 ? 3 : count);
        expect(controller.canViewAll, count > 3);
      }
      controller.onViewAll();
      expect(controller.visibleAddressCount, 4);
      expect(controller.canViewAll, isFalse);
    },
  );

  test('save refresh exposes all new and updated addresses', () async {
    final first = controller.fetchAddresses();
    repo.requests.last.complete(profile(3));
    await first;
    final refresh = controller.refreshAfterSave();
    expect(controller.screenState.value, LocationScreenState.loading);
    repo.requests.last.complete(profile(4, prefix: 'Updated'));
    await refresh;
    expect(controller.visibleAddressCount, 4);
    expect(controller.addresses.last.label, 'Updated 3');
    expect(controller.screenState.value, LocationScreenState.success);
  });

  test('an older response cannot overwrite a post-save refresh', () async {
    final older = controller.fetchAddresses();
    final newer = controller.refreshAfterSave();
    repo.requests[1].complete(profile(4));
    await newer;
    repo.requests[0].complete(profile(1));
    await older;
    expect(controller.addresses.length, 4);
  });

  test('empty refresh clears selection and failure can be retried', () async {
    controller.selectedIndex.value = 2;
    final empty = controller.fetchAddresses();
    repo.requests.last.complete(profile(0));
    await empty;
    expect(controller.selectedIndex.value, -1);
    final failed = controller.fetchAddresses();
    repo.requests.last.completeError(Exception('offline'));
    await failed;
    expect(controller.screenState.value, LocationScreenState.error);
    expect(controller.canViewAll, isFalse);
    final retry = controller.fetchAddresses();
    repo.requests.last.complete(profile(2));
    await retry;
    expect(controller.screenState.value, LocationScreenState.success);
    expect(controller.visibleAddressCount, 2);
  });
}
