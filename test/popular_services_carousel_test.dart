import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/home_screen/widgets/popular_services_row.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';
import 'package:squadonsite/presentation/screens/service_screen/service_detail_bottom_sheet.dart';

class _Home extends HomeController {
  bool fail = false;
  int requests = 0;
  final fullService = ServiceItem.fromJson({
    '_id': 'service-1',
    'name': 'Professional PC diagnosis and hardware inspection',
    'longDescription': 'Complete diagnostics with hardware checks.',
    'offerPrice': 100,
    'serviceDuration': 60,
    'addons': [
      {
        'name': 'Hardware check',
        'price': 25,
        'isActive': true,
        '_id': 'addon-1',
      },
    ],
  });
  @override
  Future<ServiceItem> loadFeaturedService(FeaturedServiceItem featured) async {
    requests++;
    if (fail) throw StateError('Unavailable');
    return fullService;
  }
}

void main() {
  late _Home controller;
  setUp(() {
    Get.testMode = true;
    controller = _Home();
    controller.featuredServices.add(
      const FeaturedServiceItem(
        id: 'service-1',
        name: 'Professional PC diagnosis and hardware inspection',
        price: 100,
        rating: 4.5,
        featuredImage: '',
      ),
    );
  });
  tearDown(() {
    controller.searchController.dispose();
    Get.reset();
  });

  Future<void> show(WidgetTester tester, {double scale = 1}) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        getPages: [
          GetPage(
            name: AppRoutes.bookServiceScreen,
            page: () => const Scaffold(body: Text('Booking destination')),
          ),
        ],
        home: Scaffold(
          body: SingleChildScrollView(
            child: PopularServicesCarousel(controller: controller),
          ),
        ),
      ),
    );
  }

  testWidgets('both actions fit at narrow width with larger text', (
    tester,
  ) async {
    await show(tester, scale: 1.5);
    expect(find.text('Book now'), findsOneWidget);
    expect(find.text('View details'), findsOneWidget);
    expect(find.text('\$100.00'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('booking receives the full service and add-ons', (tester) async {
    await show(tester);
    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();
    expect(find.text('Booking destination'), findsOneWidget);
    expect(Get.arguments, same(controller.fullService));
    expect((Get.arguments as ServiceItem).addons, hasLength(1));
    expect(controller.requests, 1);
  });

  testWidgets('details opens the existing sheet with the full service', (
    tester,
  ) async {
    await show(tester);
    await tester.tap(find.text('View details'));
    await tester.pumpAndSettle();
    final sheet = tester.widget<ServiceDetailBottomSheet>(
      find.byType(ServiceDetailBottomSheet),
    );
    expect(sheet.service, same(controller.fullService));
    expect(controller.requests, 1);
  });

  testWidgets('failed loading offers retry without navigating', (tester) async {
    controller.fail = true;
    await show(tester);
    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();
    expect(
      find.text('Unable to load this service. Please try again.'),
      findsOneWidget,
    );
    expect(find.text('Booking destination'), findsNothing);
    controller.fail = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Booking destination'), findsOneWidget);
    expect(controller.requests, 2);
  });
}
