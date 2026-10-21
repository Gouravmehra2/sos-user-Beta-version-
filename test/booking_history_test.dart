import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_controller.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_details_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_history_model.dart';

class _HistoryController extends BookingHistoryController {
  @override
  Future<void> fetchBookings() async {}
}

void main() {
  Map<String, dynamic> fixture() =>
      jsonDecode(File('test/fixtures/booking_history.json').readAsStringSync())
          as Map<String, dynamic>;

  test('preserves every field in the supplied booking response', () {
    final json = fixture();
    final response = BookingHistoryResponse.fromJson({
      'success': true,
      'data': {
        'bookings': [json],
      },
    });
    final booking = response.bookings.single;
    expect(response.success, isTrue);
    expect(booking.toJson(), equals(json));
    expect(booking.address.coordinates.lat, isNull);
    expect(booking.services.single.variantId, isNull);
    expect(booking.services.single.service.addons, hasLength(4));
  });

  test('handles absent optional details and preserves unknown array items', () {
    final booking = BookingHistoryItem.fromJson({
      'services': [
        {
          'service': {
            'variants': [
              {'custom': 'value'},
            ],
          },
          'selectedAddons': [
            {'custom': 'addon'},
          ],
        },
      ],
    });
    expect(booking.assignedTechnician.name, isEmpty);
    expect(booking.address.coordinates.lng, isNull);
    expect(booking.paymentDetails.transactionId, isEmpty);
    expect(booking.services.single.toJson()['selectedAddons'], [
      {'custom': 'addon'},
    ]);
    expect(booking.services.single.service.toJson()['variants'], [
      {'custom': 'value'},
    ]);
  });

  test('parses an existing service review', () {
    final json = fixture();
    json['services'][0]['existingReview'] = {
      '_id': '6ac97b86f42ba33427e5eab4',
      'service': '6ab1a5e4371b87cdfa865f71',
      'booking': '6ac03587fdc24f879a9a783c',
      'rating': 4,
      'review': 'big',
      'createdAt': '2026-10-09T23:40:54.224Z',
      'updatedAt': '2026-10-12T15:55:31.482Z',
    };

    final booking = BookingHistoryItem.fromJson(json);

    expect(booking.services.single.existingReview?.rating, 4);
    expect(booking.services.single.existingReview?.review, 'big');
  });

  testWidgets('shows the existing service rating on completed bookings', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    final controller = _HistoryController();
    final json = fixture()
      ..['_id'] = 'abc'
      ..['status'] = 'Completed';
    json['services'][0]['existingReview'] = {'rating': 4, 'review': 'big'};
    json['services'][0]['service']['featuredImage'] = '';
    controller.bookings.add(BookingHistoryItem.fromJson(json));
    controller.isLoading.value = false;
    Get.put<BookingHistoryController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: BookingHistoryScreen()));
    expect(find.text('Service Rating'), findsOneWidget);
    await tester.tap(find.text('Service Rating'));
    await tester.pumpAndSettle();
    expect(find.text('Previous rating: 4 stars'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders structured address and booking details at narrow width',
    (tester) async {
      Get.testMode = true;
      addTearDown(Get.reset);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = _HistoryController();
      final json = fixture()..['_id'] = 'abc';
      json['services'][0]['service']['featuredImage'] = '';
      json['services'][0]['selectedAddons'] = ['6ab561352429ecd5002003b8'];
      controller.bookings.add(BookingHistoryItem.fromJson(json));
      controller.isLoading.value = false;
      Get.put<BookingHistoryController>(controller);
      await tester.pumpWidget(
        const GetMaterialApp(home: BookingHistoryScreen()),
      );
      expect(find.text('PC Diagnosis'), findsOneWidget);
      expect(find.textContaining('Home · ofice'), findsOneWidget);
      expect(find.text('Booking ID: abc'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Confirmed'), findsWidgets);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('View details'));
      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();
      expect(find.byType(BookingDetailsScreen), findsOneWidget);
      expect(find.text('Confirmed'), findsWidgets);
      expect(find.text('1234567890'), findsOneWidget);
      expect(find.text('Additional items'), findsOneWidget);
      expect(find.text('Hardware Health Check'), findsOneWidget);
      expect(find.text('Selected add-ons'), findsNothing);
      expect(find.text('4.9'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byKey(const ValueKey('booking-details-scroll')),
        const Offset(0, -650),
      );
      await tester.pumpAndSettle();
      expect(find.text('pi_3UKjo8LoofSnTZCg047MfV4J'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Service information'));
      await tester.tap(find.text('Service information'));
      await tester.pumpAndSettle();
      expect(find.text('Initial PC inspection'), findsOneWidget);
      expect(find.text('Replacement hardware'), findsOneWidget);
      expect(find.text('PC available for diagnosis'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'missing details and unpaid status render without invented data',
    (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final booking = BookingHistoryItem.fromJson({
        'status': 'Cancelled',
        'paymentStatus': 'Unpaid',
      });
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.4)),
            child: child!,
          ),
          home: BookingDetailsScreen(booking: booking),
        ),
      );
      expect(find.text('Unpaid'), findsNWidgets(2));
      expect(find.text('Technician not assigned'), findsOneWidget);
      expect(find.text('Date to be confirmed'), findsOneWidget);
      expect(find.text('Address not provided'), findsOneWidget);
      expect(find.text('Amount Paid'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
