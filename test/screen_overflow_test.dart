// Test controllers intentionally skip network and navigation initialization.
// ignore_for_file: must_call_super

import 'package:squadonsite/presentation/screens/dashboard/dasboard_screen.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_controller.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/user_stories_row.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_screen.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_screen.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_controller.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_controller.dart';
import 'package:squadonsite/presentation/screens/book_service_screen/book_service_screen.dart';
import 'package:squadonsite/translations/app_translations.dart';

final fixtureService = ServiceItem.fromJson({
  'name': 'Complete home appliance installation and maintenance service',
  'offerPrice': 12345,
  'ratingsAverage': 4.95,
  'ratingsQuantity': 123456,
});

class _Home extends HomeController {
  @override
  void onInit() {
    userName = 'A very long customer name for layout testing';
    featuredServices.assignAll(
      List.generate(
        30,
        (i) => FeaturedServiceItem(
          id: '$i',
          name: 'Long featured service name for layout testing',
          price: 12345,
          rating: 4.9,
          featuredImage: '',
        ),
      ),
    );
  }

  @override
  List<UserStory> get userStories => [];
}

class _Services extends ServiceController {
  @override
  void onInit() {
    isLoadingSubcategories.value = false;
    services.assignAll([fixtureService, fixtureService, fixtureService]);
    subcategories.add(
      const SubcategoryItem(
        id: '1',
        name: 'Home appliances installation',
        image: '',
        icon: '',
        startingFromPrice: 20,
      ),
    );
  }
}

class _Profile extends ProfileController {
  @override
  void onInit() {
    userName.value = 'A very long customer name for layout testing';
    referralCode.value = 'LONG-REFERRAL-CODE-123456789';
  }
}

class _Booking extends BookServiceController {
  @override
  void onInit() {
    service = fixtureService;
  }
}

class _Bookings extends BookingHistoryController {
  @override
  void onInit() {
    isLoading.value = false;
  }
}

void main() {
  testWidgets('dashboard creates each tab only when opened and retains it', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    final dashboard = Get.put(DashboardController());
    Get.put<HomeController>(_Home());
    var servicesCreated = 0;
    var profilesCreated = 0;
    var bookingsCreated = 0;
    Get.lazyPut<ServiceController>(() {
      servicesCreated++;
      return _Services();
    });
    Get.lazyPut<ProfileController>(() {
      profilesCreated++;
      return _Profile();
    });
    Get.lazyPut<BookingHistoryController>(() {
      bookingsCreated++;
      return _Bookings();
    });
    await tester.pumpWidget(GetMaterialApp(home: const DashboardScreen()));
    await tester.pump();
    expect([servicesCreated, profilesCreated, bookingsCreated], [0, 0, 0]);
    for (final index in [1, 2, 3, 4, 0, 1, 2, 3, 4]) {
      dashboard.changeIndex(index: index);
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
    expect([servicesCreated, profilesCreated, bookingsCreated], [1, 1, 1]);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('home stories do not allocate a player before a tap', (
    tester,
  ) async {
    final controller = HomeController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: UserStoriesRow(controller: controller)),
      ),
    );
    await tester.pump();
    expect(find.byType(VideoPlayer), findsNothing);
    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    controller.onClose();
  });

  for (final width in [320.0, 390.0, 600.0]) {
    for (final scale in [1.0, 2.0]) {
      for (final screen in ['home', 'services', 'profile', 'booking']) {
        testWidgets('$screen width=$width scale=$scale', (tester) async {
          Get.testMode = true;
          tester.view.physicalSize = Size(width, 700);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(Get.reset);
          late Widget child;
          switch (screen) {
            case 'home':
              Get.put<HomeController>(_Home());
              child = const HomeScreen();
            case 'services':
              Get.put<ServiceController>(_Services());
              child = ServiceScreen();
            case 'profile':
              Get.put<ProfileController>(_Profile());
              child = ProfileScreen();
            case 'booking':
              Get.put<BookServiceController>(_Booking());
              child = const BookServiceScreen();
          }
          await tester.pumpWidget(
            GetMaterialApp(
              translations: AppTranslations(),
              locale: const Locale('es'),
              home: child,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));
          expect(tester.takeException(), isNull);
          final scrollables = find.byType(Scrollable);
          if (scrollables.evaluate().isNotEmpty) {
            final target = screen == 'services'
                ? scrollables.last
                : scrollables.first;
            for (var i = 0; i < 5; i++) {
              await tester.drag(target, const Offset(0, -450));
              await tester.pump(const Duration(milliseconds: 100));
              expect(tester.takeException(), isNull);
            }
          }
          if (screen == 'booking') {
            tester.view.viewInsets = const FakeViewPadding(bottom: 300);
            addTearDown(tester.view.resetViewInsets);
            await tester.pump();
            expect(tester.takeException(), isNull);
          }
          await tester.pumpWidget(const SizedBox.shrink());
        });
      }
    }
  }
}
