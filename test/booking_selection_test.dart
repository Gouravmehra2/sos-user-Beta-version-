import 'dart:convert';
import 'dart:async';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_binding.dart';
import 'package:squadonsite/presentation/screens/select_location_screen/select_location_controller.dart';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_controller.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_screen.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/widgets/addon_selector.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_detail_bottom_sheet.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';

ServiceItem fixture() => ServiceListResponse.fromJson(
  jsonDecode(File('test/fixtures/services_response.json').readAsStringSync()),
).services.single;

class _Repo implements ApiRepo {
  final defaultAddressIds = <String>[];
  Completer<List<UserAddress>>? defaultUpdate;
  @override
  Future<List<UserAddress>> setDefaultAddress(String id) {
    defaultAddressIds.add(id);
    defaultUpdate = Completer<List<UserAddress>>();
    return defaultUpdate!.future;
  }

  @override
  Future<HomeProfileResponse> meProfile() async =>
      HomeProfileResponse.fromJson({
        'success': true,
        'data': {
          'user': {
            'phone': '+15551234567',
            'selectedAddressId': 'home',
            'addresses': [
              {
                '_id': 'home',
                'id': 'home',
                'addressLine': '123 Main Street',
                'city': 'Austin',
              },
            ],
          },
        },
      });
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// The test supplies a service directly instead of using a navigation route.
class _Controller extends BookServiceController {
  @override
  void onInit() {} // ignore: must_call_super
}

void main() {
  test('booking request matches the API service and date contract', () {
    final controller = BookServiceController()..service = fixture();
    controller.selectedVariant.value = controller.service.variants.first;
    controller.toggleAddon(controller.service.addons.first);
    controller.serviceDate.value = DateTime.parse('2026-10-01T18:04:53.570Z');
    controller.selectedAddress.value = UserAddress.fromJson({
      'label': 'Home',
      'name': 'Alex',
      'addressLine': '123 Main Street',
      'city': 'Austin',
      'state': 'TX',
      'zipcode': '78701',
      'latitude': 30.26,
      'longitude': -97.74,
    });
    controller.phoneController.text = '+15551234567';
    expect(controller.buildBookingPayload(), {
      'services': [
        {
          'service': controller.service.id,
          'quantity': 1,
          'variantId': controller.service.variants.first.id,
          'addonIds': [controller.service.addons.first.id],
        },
      ],
      'address': {
        'label': 'Home',
        'name': 'Alex',
        'addressLine': '123 Main Street',
        'buildingFloor': '',
        'street': '',
        'city': 'Austin',
        'state': 'TX',
        'zipcode': '78701',
        'coordinates': {'lat': 30.26, 'lng': -97.74},
      },
      'phone': '+15551234567',
      'serviceDate': '2026-10-01T18:04:53.570Z',
      'specialInstructions': '',
    });
    controller.onClose();
  });

  test(
    'editing checkout address text drops the previous saved coordinates',
    () {
      final controller = BookServiceController()..service = fixture();
      const saved = UserAddress(
        id: 'saved-id',
        label: 'Home',
        addressLine: 'Main Street',
        city: 'City',
        state: '',
        zipcode: '',
        latitude: 0,
        longitude: 0,
        house: 'Flat 5',
      );
      controller.selectedAddress.value = saved;
      controller.addressController.text = saved.displayAddress;
      expect(controller.buildBookingPayload()['address']['coordinates'], {
        'lat': 0,
        'lng': 0,
      });
      controller.addressController.text = 'Another Street';
      expect(controller.selectedAddress.value, isNull);
      expect(controller.buildBookingPayload()['address'], {
        'addressLine': 'Another Street',
        'city': '',
        'state': '',
        'zipcode': '',
      });
      controller.onClose();
    },
  );

  testWidgets(
    'tapping a checkout address saves the default and returns its updated location',
    (tester) async {
      Get.testMode = true;
      final repo = _Repo();
      Get.put<ApiRepo>(repo);
      final controller = Get.put<BookServiceController>(
        _Controller()..service = fixture(),
        permanent: true,
      );
      addTearDown(Get.reset);
      await controller.loadProfile();
      await tester.pumpWidget(
        GetMaterialApp(
          home: const BookServiceScreen(),
          getPages: [
            GetPage(
              name: AppRoutes.selectLocationScreen,
              binding: SelectLocationBinding(),
              page: () {
                Get.find<SelectLocationController>();
                return const Scaffold(body: Text('Select address'));
              },
            ),
          ],
        ),
      );
      var changed = false;
      controller.changeAddress().then((_) => changed = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final picker = Get.find<SelectLocationController>();
      const office = UserAddress(
        id: 'office',
        label: 'Office',
        addressLine: 'Office Road',
        city: 'Austin',
        state: 'TX',
        zipcode: '78701',
        isDefault: true,
        latitude: 0,
        longitude: 0,
      );
      picker.addresses.add(office);
      final save = picker.selectAddress(1);
      expect(repo.defaultAddressIds, ['office']);
      expect(picker.savingIndex.value, 1);
      picker.onConfirmLocation();
      expect(Get.currentRoute, AppRoutes.selectLocationScreen);
      repo.defaultUpdate!.complete([picker.addresses.first, office]);
      await save;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(changed, isTrue);
      expect(controller.selectedAddress.value?.id, 'office');
      expect(controller.addressController.text, office.displayAddress);
      expect(controller.buildBookingPayload()['address']['coordinates'], {
        'lat': 0,
        'lng': 0,
      });
      expect(find.text(office.displayAddress), findsOneWidget);
      // The already-default address also returns on tap, without another PUT.
      changed = false;
      controller.changeAddress().then((_) => changed = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      final reopenedPicker = Get.find<SelectLocationController>();
      await reopenedPicker.selectAddress(reopenedPicker.selectedIndex.value);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(changed, isTrue);
      expect(controller.selectedAddress.value?.id, 'home');
      expect(repo.defaultAddressIds, ['office']);
      expect(find.text(controller.addressController.text), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  test('phone number uses the selected country dial code', () {
    final controller = BookServiceController()..service = fixture();

    expect(controller.selectedCountry.value.code, 'US');
    controller.phoneController.text = '555 123 4567';
    expect(controller.buildBookingPayload()['phone'], '+15551234567');

    controller.onCountryChanged(
      CountryCode(code: 'GB', dialCode: '+44', name: 'United Kingdom'),
    );
    controller.phoneController.text = '020 7123 4567';
    expect(controller.buildBookingPayload()['phone'], '+4402071234567');
    controller.onClose();
  });

  test('add-ons update totals and booking payload without tax', () {
    final controller = BookServiceController()..service = fixture();
    controller.selectedVariant.value = controller.service.variants.first;
    final addon = controller.service.addons.first;
    expect(controller.total, 134);
    controller.toggleAddon(addon);
    expect(controller.total, 183);
    expect(controller.buildBookingPayload()['services'][0]['addonIds'], [
      addon.id,
    ]);
    expect(controller.buildBookingPayload()['services'], [
      {
        'service': controller.service.id,
        'quantity': 1,
        'variantId': controller.service.variants.first.id,
        'addonIds': [addon.id],
      },
    ]);
    controller.bookingForSomeoneElse.value = true;
    controller.contactNameController.text = 'Alex';
    controller.alternatePhoneController.text = '+15559876543';
    expect(controller.buildBookingPayload()['contactName'], 'Alex');
    expect(controller.buildBookingPayload()['phone'], '+15559876543');
    controller.toggleAddon(addon);
    expect(controller.total, 134);
    expect(
      controller.buildBookingPayload()['services'][0]['addonIds'],
      isEmpty,
    );
    controller.onClose();
  });

  test('checkout includes both add-ons and rejects a different charge', () {
    final controller = BookServiceController()..service = fixture();
    controller.selectedVariant.value = controller.service.variants.first;
    for (final addon in controller.service.addons.take(2)) {
      controller.toggleAddon(addon);
    }
    controller.selectedAddonIds.add('unknown-addon');
    expect(controller.buildBookingPayload()['services'][0]['addonIds'], [
      '6ab563152429ecd500201663',
      '6ab563152429ecd500201664',
    ]);
    expect(controller.total, 222);
    expect(controller.matchesCheckoutAmount(22200, 'usd'), isTrue);
    expect(controller.matchesCheckoutAmount(22200, 'USD'), isTrue);
    expect(controller.matchesCheckoutAmount(13400, 'usd'), isFalse);
    expect(controller.matchesCheckoutAmount(22201, 'usd'), isFalse);
    expect(controller.matchesCheckoutAmount(22200, 'cad'), isFalse);
    expect(controller.matchesCheckoutAmount(0, 'usd'), isFalse);
    controller.onClose();
  });

  test('contact number validation accepts formatted numbers', () {
    expect(BookServiceController.validatePhone('+1 (555) 123-4567'), isNull);
    expect(BookServiceController.validatePhone(''), isNotNull);
    expect(BookServiceController.validatePhone('abc1234567890'), isNotNull);
  });

  testWidgets('add-ons update checkout and survive package changes', (
    tester,
  ) async {
    Get.testMode = true;
    Get.put<ApiRepo>(_Repo());
    final controller = Get.put<BookServiceController>(
      _Controller()..service = fixture(),
    );
    controller.selectedVariant.value = controller.service.variants.first;
    addTearDown(Get.reset);
    await controller.loadProfile();
    await tester.pumpWidget(GetMaterialApp(home: const BookServiceScreen()));
    final addons = controller.service.addons.take(2).toList();
    for (final addon in addons) {
      final toggle = find.byKey(ValueKey('toggle-addon-${addon.id}'));
      await tester.ensureVisible(toggle);
      await tester.tap(toggle);
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(controller.total, 222);
    expect(find.text(r'$222.00'), findsWidgets);
    expect(
      controller.buildBookingPayload()['services'][0]['addonIds'],
      addons.map((a) => a.id).toList(),
    );

    final package = find.text(controller.service.variants[1].name);
    await tester.ensureVisible(package);
    await tester.tap(package);
    await tester.pump(const Duration(milliseconds: 300));
    expect(controller.total, 312);
    expect(find.text(r'$312.00'), findsWidgets);

    final remove = find.byKey(ValueKey('toggle-addon-${addons.first.id}'));
    await tester.ensureVisible(remove);
    await tester.tap(remove);
    await tester.pump(const Duration(milliseconds: 300));
    expect(controller.total, 263);
    expect(controller.buildBookingPayload()['services'][0]['addonIds'], [
      addons.last.id,
    ]);

    controller.isLoading.value = true;
    await tester.pump();
    await tester.tap(remove);
    await tester.pump();
    expect(controller.total, 263);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'booking loads profile, shows horizontal add-ons and alternate contact form',
    (tester) async {
      Get.testMode = true;
      Get.put<ApiRepo>(_Repo());
      final controller = Get.put<BookServiceController>(
        _Controller()..service = fixture(),
      );
      controller.selectedVariant.value = controller.service.variants.first;
      addTearDown(Get.reset);
      await controller.loadProfile();
      expect(controller.addressController.text, contains('123 Main Street'));
      expect(controller.phoneController.text, '5551234567');
      await tester.pumpWidget(GetMaterialApp(home: const BookServiceScreen()));
      await tester.pump();
      expect(find.text(controller.service.name), findsWidgets);
      expect(find.byType(AddonSelector), findsOneWidget);
      controller.toggleAddon(controller.service.addons.first);
      controller.bookingForSomeoneElse.value = true;
      await tester.pump();
      expect(find.text("Person's full name"), findsOneWidget);
      expect(find.text("Person's contact number"), findsOneWidget);
      expect(find.textContaining('Taxes'), findsNothing);
      expect(controller.total, 183);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('service detail total includes selected add-ons', (tester) async {
    Get.testMode = true;
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final service = fixture();
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  Get.bottomSheet(ServiceDetailBottomSheet(service: service)),
              child: const Text('Open service'),
            ),
          ),
        ),
      ),
    );
    addTearDown(Get.reset);

    await tester.tap(find.text('Open service'));
    await tester.pumpAndSettle();
    expect(find.text(r'$134'), findsWidgets);

    final addon = service.addons.first;
    final toggle = find.byKey(ValueKey('toggle-addon-${addon.id}'));
    await tester.ensureVisible(toggle);
    await tester.tap(toggle);
    await tester.pump();

    expect(find.text(r'$183'), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
