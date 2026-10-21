import 'package:flutter/material.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squadonsite/presentation/screens/address_form_screen/address_form_controller.dart';
import 'package:squadonsite/presentation/screens/address_form_screen/address_form_screen.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/map_picker_screen/map_picker_controller.dart';

class FailingAddressRepo implements ApiRepo {
  int saveCalls = 0;
  @override
  Future<List<UserAddress>> getAddresses() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #addAddress) {
      saveCalls++;
      return Future<List<UserAddress>>.error(Exception('offline'));
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  tearDown(() => Get.reset());

  test('saved coordinates survive address serialization, including zero', () {
    final address = UserAddress.fromJson({
      'id': 'a',
      'latitude': '0',
      'longitude': 76.85,
      'house': 'Flat 4',
      'building': 'Main road',
      'area': 'Sector 2',
      'addressType': 'Office',
    });
    final restored = UserAddress.fromJson(address.toJson());
    expect(restored.house, 'Flat 4');
    expect(restored.building, 'Main road');
    expect(restored.area, 'Sector 2');
    expect(restored.addressType, 'Office');
    expect(restored.latitude, 0);
    expect(restored.longitude, 76.85);
    expect(UserAddress.fromJson({}).latitude, isNull);
  });

  test('address schema aliases populate the form and Area display', () {
    Get.routing.args = {
      'addressLine':
          'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
      'buildingFloor': 'CXO Suits Ground floor',
      'city': 'Devpura road',
      'id': '6acffd44eba70f575cd9a5de',
      'label': 'Office',
      'name': '',
      'state': 'Uttarakhand',
      'street': 'Sector 28 Road',
      'zipcode': '249401',
    };
    final controller = AddressFormController()..onInit();

    expect(controller.isEditMode, isTrue);
    expect(controller.houseController.text, 'CXO Suits Ground floor');
    expect(controller.buildingController.text, 'Sector 28 Road');
    expect(controller.selectedLabel.value, AddressLabel.office);
    expect(controller.cityController.text, 'Devpura road');
    expect(controller.stateController.text, 'Uttarakhand');
    expect(controller.zipcodeController.text, '249401');
    expect(
      controller.area.value,
      'Haridwar Railway Station Grounds, Shikhu Pur, Devpura, Haridwar, Uttarakhand 249401, India',
    );
    expect(controller.hasUsableLocation, isTrue);
    controller.onClose();
  });

  test('nested coordinates retain zero and reject invalid values', () {
    final address = UserAddress.fromJson({
      '_id': 'saved-id',
      'coordinates': {'lat': 0, 'lng': 0},
    });
    expect(address.latitude, 0);
    expect(address.longitude, 0);
    expect(
      UserAddress.fromJson({
        'coordinates': {'lat': 91, 'lng': double.nan},
      }).latitude,
      isNull,
    );
    expect(
      UserAddress.fromJson({
        'coordinates': {'lat': 91, 'lng': double.nan},
      }).longitude,
      isNull,
    );
  });

  test(
    'manual address identity edits clear coordinates but keep building and label',
    () {
      Get.routing.args = {
        'latLng': const LatLng(0, 0),
        'addressLine': 'Old Street',
        'city': 'City',
        'label': 'Office',
        'buildingFloor': 'Flat 4',
      };
      final controller = AddressFormController()..onInit();
      controller.houseController.text = 'Flat 5';
      expect(controller.selectedLocation.value, const LatLng(0, 0));
      controller.cityController.text = 'Another city';
      expect(controller.selectedLocation.value, isNull);
      expect(controller.houseController.text, 'Flat 5');
      expect(controller.selectedLabel.value, AddressLabel.office);
      controller.onClose();
    },
  );

  test('saved address model supports the supplied address keys', () {
    final address = UserAddress.fromJson({
      'addressLine': 'Haridwar Railway Station Grounds, Devpura',
      'buildingFloor': 'CXO Suits Ground floor',
      'city': 'Devpura road',
      'id': 'saved-id',
      'label': 'Office',
      'name': '',
      'state': 'Uttarakhand',
      'street': 'Sector 28 Road',
      'zipcode': '249401',
    });

    expect(address.id, 'saved-id');
    expect(address.house, 'CXO Suits Ground floor');
    expect(address.building, 'Sector 28 Road');
    expect(address.area, 'Haridwar Railway Station Grounds, Devpura');
  });

  test('legacy saved address does not require another map selection', () {
    Get.routing.args = {
      'addressId': 'saved',
      'display': 'Sector 2, City',
      'house': 'Flat 4',
      'label': 'Home',
    };
    final controller = AddressFormController()..onInit();
    expect(controller.selectedLocation.value, isNull);
    expect(controller.hasUsableLocation, isTrue);
    controller.houseController.text = 'Flat 5';
    expect(controller.hasUsableLocation, isTrue);
    controller.onClose();
  });

  test(
    'coordinates are optional for manual entry and confirmed pins remain reusable',
    () {
      Get.routing.args = {'display': 'Sector 2, City'};
      final controller = AddressFormController()..onInit();
      expect(controller.hasUsableLocation, isFalse);
      controller.selectedLocation.value = const LatLng(30.7, 76.8);
      expect(controller.hasUsableLocation, isTrue);
      controller.houseController.text = 'Flat 5';
      expect(controller.hasUsableLocation, isTrue);
      controller.onClose();
    },
  );

  test('house and building details do not move the selected map pin', () {
    const selectedPoint = LatLng(30.7, 76.8);
    Get.routing.args = {
      'latLng': selectedPoint,
      'addressLine': 'Main Street',
      'display': 'Main Street, City',
      'city': 'City',
    };
    final controller = AddressFormController()..onInit();
    controller.houseController.text = 'Flat 5';
    controller.buildingController.text = 'Building A';

    expect(controller.selectedLocation.value, selectedPoint);
    expect(controller.area.value, 'Main Street, City');
    expect(controller.hasUsableLocation, isTrue);
    controller.onClose();
  });

  test('Change picker opens at the supplied saved location without GPS', () {
    const savedPoint = LatLng(30.7, 76.8);
    Get.routing.args = {
      'initialLatLng': savedPoint,
      'returnSelection': true,
      'displayAddress': 'Sector 2, City',
    };
    final controller = MapPickerController()..onInit();
    expect(controller.initialCameraTarget, savedPoint);
    expect(controller.initialCameraZoom, 19);
    expect(controller.searchController.text, 'Sector 2, City');
    expect(controller.searchText.value, 'Sector 2, City');
    expect(controller.isLocating.value, isFalse);
    controller.onClose();
  });

  test('moving the pin invalidates the old address immediately', () {
    final controller = MapPickerController();
    controller.geocodeResult.value = const ReverseGeocodeResult(
      addressLine: 'Old road',
      city: 'City',
      state: 'State',
      zipcode: '123456',
      display: 'Old road',
    );
    expect(controller.canConfirm, isTrue);
    controller.onCameraMove(
      const CameraPosition(target: LatLng(30, 76), zoom: 16),
    );
    expect(controller.canConfirm, isFalse);
    expect(controller.geocodeResult.value.display, isEmpty);
    expect(controller.centerLatLng.value, const LatLng(30, 76));
    controller.onClose();
  });

  for (final width in [320.0, 390.0]) {
    testWidgets('form validates required details and fits width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 850);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Get.testMode = true;
      final controller = Get.put(AddressFormController());
      await tester.pumpWidget(const GetMaterialApp(home: AddressFormScreen()));
      expect(find.text('Location Details'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Office'), findsOneWidget);
      expect(controller.formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(tester.takeException(), isNull);
      controller.houseController.text = '   ';
      controller.addressLineController.text = '   ';
      expect(controller.formKey.currentState!.validate(), isFalse);
      controller.houseController.text = 'Flat 4';
      controller.addressLineController.text = 'Main Street';
      expect(controller.formKey.currentState!.validate(), isTrue);
      controller.selectLabel(AddressLabel.work);
      expect(controller.selectedLabel.value, AddressLabel.work);
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }
  testWidgets('failed optional profile save keeps checkout draft usable', (
    tester,
  ) async {
    Get.testMode = true;
    final repo = FailingAddressRepo();
    Get.put<ApiRepo>(repo);
    Get.routing.args = {
      'checkoutMode': true,
      'latLng': const LatLng(0, 0),
      'addressLine': 'Main Street',
      'city': 'City',
      'buildingFloor': 'Flat 5',
      'label': 'Office',
    };
    final controller = Get.put(AddressFormController(), permanent: true);
    await tester.pumpWidget(
      GetMaterialApp(
        home: const Scaffold(body: Text('Checkout')),
        getPages: [
          GetPage(name: '/new-address', page: () => const AddressFormScreen()),
        ],
      ),
    );
    final result = Get.toNamed(
      '/new-address',
      arguments: {
        'checkoutMode': true,
        'latLng': const LatLng(0, 0),
        'addressLine': 'Main Street',
        'city': 'City',
        'buildingFloor': 'Flat 5',
        'label': 'Office',
      },
    );
    await tester.pumpAndSettle();
    expect(controller.saveToProfile.value, isFalse);
    controller.saveToProfile.value = true;
    await controller.saveAddress();
    await tester.pumpAndSettle();
    expect(repo.saveCalls, 1);
    expect(
      controller.saveError.value,
      contains('Could not save to your profile'),
    );
    expect(controller.addressLineController.text, 'Main Street');
    expect(controller.selectedLocation.value, const LatLng(0, 0));
    expect(controller.houseController.text, 'Flat 5');
    controller.saveToProfile.value = false;
    await controller.saveAddress();
    await tester.pumpAndSettle();
    final address = await result as UserAddress;
    expect(address.id, isEmpty);
    expect(address.label, 'Office');
    expect(address.latitude, 0);
    expect(repo.saveCalls, 1);
    await tester.pump(const Duration(seconds: 4));
  });
}
