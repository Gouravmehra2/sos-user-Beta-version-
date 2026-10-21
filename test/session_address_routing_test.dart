import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'package:squadonsite/presentation/screens/home_screen/model/home_screen_model.dart';
import 'package:squadonsite/presentation/screens/splash_screen/splash_controller.dart';
import 'package:squadonsite/presentation/screens/address_form_screen/address_form_controller.dart';
import 'package:squadonsite/presentation/screens/address_form_screen/address_form_screen.dart';

class _ProfileRepo implements ApiRepo {
  HomeProfileUser profile = const HomeProfileUser();
  Object? error;
  @override
  Future<HomeProfileResponse> meProfile() async {
    if (error != null) throw error!;
    return HomeProfileResponse(
      success: true,
      data: HomeProfileData(user: profile),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

UserAddress address(String id, {bool isDefault = false}) => UserAddress(
  id: id,
  label: 'Home',
  addressLine: 'Flat $id',
  city: 'City',
  state: 'State',
  zipcode: '123456',
  isDefault: isDefault,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    Get.testMode = true;
  });
  tearDown(() => Get.reset());

  test('login token survives profile-only update and app restart', () async {
    final session = AuthSession();
    await session.update(
      const AuthResponse(
        success: true,
        accessToken: 'test-access',
        refreshToken: 'test-refresh',
      ),
    );
    await session.update(const AuthResponse(success: true));
    final restored = AuthSession();
    await restored.restoreFromStorage();
    expect(restored.accessToken, 'test-access');
    expect(restored.refreshToken, 'test-refresh');
    expect(
      (await SharedPreferences.getInstance()).getString('auth_token'),
      isNull,
    );
    expect(
      await const FlutterSecureStorage().read(key: 'auth_token'),
      'test-access',
    );
    await restored.clearSession();
    await AuthSession().restoreFromStorage();
    expect(
      (await SharedPreferences.getInstance()).getString('auth_token'),
      isNull,
    );
  });

  test(
    'legacy credentials migrate to secure storage and plaintext is removed',
    () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'legacy-access',
        'refresh_token': 'legacy-refresh',
      });
      final session = AuthSession();
      await session.restoreFromStorage();
      expect(session.accessToken, 'legacy-access');
      expect(session.refreshToken, 'legacy-refresh');
      expect(
        await const FlutterSecureStorage().read(key: 'auth_token'),
        'legacy-access',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), isNull);
      expect(prefs.getString('refresh_token'), isNull);
      await session.clearSession();
      expect(
        await const FlutterSecureStorage().read(key: 'auth_token'),
        isNull,
      );
    },
  );

  test(
    'selected ID wins over default flag; default wins over first address',
    () {
      final list = [address('a'), address('b', isDefault: true), address('c')];
      expect(
        HomeProfileUser(
          addresses: list,
          selectedAddressId: 'c',
        ).defaultAddress?.id,
        'c',
      );
      expect(HomeProfileUser(addresses: list).defaultAddress?.id, 'b');
      expect(const HomeProfileUser().defaultAddress, isNull);
    },
  );

  for (final scenario in ['empty', 'saved', 'offline', 'expired']) {
    testWidgets('startup handles $scenario session', (tester) async {
      SharedPreferences.setMockInitialValues({'auth_token': 'test-access'});
      final session = Get.put(AuthSession());
      final repo = _ProfileRepo();
      if (scenario == 'saved') {
        repo.profile = HomeProfileUser(addresses: [address('a')]);
      }
      if (scenario == 'offline') {
        repo.error = const ApiException(message: 'offline');
      }
      if (scenario == 'expired') {
        repo.error = const ApiException(message: 'expired', statusCode: 401);
      }
      Get.put<ApiRepo>(repo);
      await tester.pumpWidget(
        GetMaterialApp(
          home: const Scaffold(body: Text('Start')),
          getPages: [
            GetPage(
              name: AppRoutes.dashboardScreen,
              page: () => const Scaffold(body: Text('Dashboard')),
            ),
            GetPage(
              name: AppRoutes.locationPermissionScreen,
              page: () => const Scaffold(body: Text('Location choice')),
            ),
            GetPage(
              name: AppRoutes.onboardingScreen,
              page: () => const Scaffold(body: Text('Onboarding')),
            ),
          ],
        ),
      );
      final controller = SplashController();
      await tester.runAsync(controller.checkAuthState);
      await tester.pumpAndSettle();
      if (scenario == 'saved') expect(find.text('Dashboard'), findsOneWidget);
      if (scenario == 'empty') {
        expect(find.text('Location choice'), findsOneWidget);
      }
      if (scenario == 'expired') {
        expect(find.text('Onboarding'), findsOneWidget);
        expect(session.hasToken, isFalse);
      } else {
        expect(session.hasToken, isTrue);
      }
      if (scenario == 'offline') {
        expect(controller.error.value, isNotEmpty);
        expect(find.text('Start'), findsOneWidget);
      }
      controller.onClose();
    });
  }

  testWidgets('manual addresses can be entered without a map selection', (
    tester,
  ) async {
    Get.routing.args = {'manualEntry': true, 'addressOnboarding': true};
    final controller = Get.put(AddressFormController());
    await tester.pumpWidget(const GetMaterialApp(home: AddressFormScreen()));
    expect(
      find.text('Search on the map or enter the address below'),
      findsOneWidget,
    );
    expect(controller.hasUsableLocation, isFalse);
    controller.area.value = 'Sector 4';
    controller.cityController.text = 'City';
    controller.stateController.text = 'State';
    controller.zipcodeController.text = '123456';
    controller.houseController.text = 'Flat 5';
    controller.addressLineController.text = 'Sector 4';
    expect(controller.hasUsableLocation, isFalse);
    expect(controller.formKey.currentState!.validate(), isTrue);
    expect(controller.selectedLocation.value, isNull);
    await tester.pumpWidget(const SizedBox());
  });
  test(
    'confirmed map location prefills address fields and needs no second pin',
    () {
      Get.routing.args = {
        'latLng': const LatLng(30.7, 76.8),
        'addressLine': 'Sector 4',
        'display': 'Sector 4, Chandigarh 160004, India',
        'city': 'Chandigarh',
        'state': 'Chandigarh',
        'zipcode': '160004',
        'addressOnboarding': true,
      };
      final controller = AddressFormController()..onInit();
      expect(controller.cityController.text, 'Chandigarh');
      expect(controller.stateController.text, 'Chandigarh');
      expect(controller.zipcodeController.text, '160004');
      expect(controller.hasUsableLocation, isTrue);
      expect(controller.houseController.text, isEmpty);
      controller.houseController.text = 'Flat 4';
      expect(controller.hasUsableLocation, isTrue);
      controller.onClose();
    },
  );
}
