import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_details_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/invoice_screen.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_history_model.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_invoice_model.dart';

const _invoiceJson = <String, dynamic>{
  'success': true,
  'data': {
    'invoice': {
      'invoiceNumber': 'INV-9A9A783C',
      'bookingId': '6ac03587fdc24f879a9a783c',
      'invoiceDate': '2026-10-02T22:51:51.671Z',
      'scheduledDate': '2026-10-02T18:30:00.000Z',
      'status': 'Completed',
      'paymentStatus': 'Paid',
      'currency': 'USD',
      'company': {
        'name': 'SOS',
        'website': 'www.1app.com',
        'email': 'support@1app.com',
        'phone': '+1 (253) 3667 557',
      },
      'customer': {
        'name': 'Mayank',
        'email': 'mayank@test.com',
        'phone': '7894561230',
        'address': {
          'addressLine': 'ofice, Kishangarh, Kishangarh,, Sector 7 MDC',
          'city': 'Panchkula',
          'state': 'Haryana',
          'zipcode': '134109',
          'formatted':
              'ofice, Kishangarh, Kishangarh,, Sector 7 MDC, Panchkula, Haryana, 134109',
        },
      },
      'services': [
        {
          'lineNumber': 1,
          'serviceId': '6ab1a5e4371b87cdfa865f71',
          'name': 'PC Virus Removal',
          'variantName': 'Basic Virus Scan & Removal',
          'addons': [
            {'name': 'Deep Malware Scan', 'price': 29},
          ],
          'quantity': 1,
          'unitPrice': 69,
          'amount': 69,
        },
      ],
      'totals': {
        'subtotal': 69,
        'adjustments': 0,
        'totalAmount': 69,
        'paidAmount': 69,
        'balanceDue': 0,
      },
      'download': {
        'url': '/api/bookings/6ac03587fdc24f879a9a783c/invoice',
        'contentType': 'text/plain',
        'filename': 'invoice-6ac03587fdc24f879a9a783c.txt',
      },
    },
  },
};

class _RecordingDioClient extends DioClient {
  final paths = <String>[];

  @override
  Future<dio.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    dio.Options? options,
  }) async {
    paths.add(path);
    final data = path.endsWith('/details')
        ? _invoiceJson
        : Uint8List.fromList('invoice text'.codeUnits);
    optionsSeen.add(options);
    return dio.Response(
      requestOptions: dio.RequestOptions(path: path),
      data: data,
    );
  }

  final optionsSeen = <dio.Options?>[];
}

class _InvoiceRepo implements ApiRepo {
  @override
  Future<BookingInvoice> getBookingInvoice(String bookingId) async {
    final data = _invoiceJson['data'] as Map<String, dynamic>;
    return BookingInvoice.fromJson(data['invoice'] as Map<String, dynamic>);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('maps the complete invoice response structure', () {
    final payload = _invoiceJson['data'] as Map<String, dynamic>;
    final invoice = BookingInvoice.fromJson(
      payload['invoice'] as Map<String, dynamic>,
    );
    expect(invoice.invoiceNumber, 'INV-9A9A783C');
    expect(invoice.bookingId, '6ac03587fdc24f879a9a783c');
    expect(invoice.invoiceDate?.isUtc, isTrue);
    expect(invoice.customer.address.formatted, contains('Panchkula'));
    expect(invoice.services.single.name, 'PC Virus Removal');
    expect(invoice.services.single.variantName, 'Basic Virus Scan & Removal');
    expect(invoice.services.single.addons.single.name, 'Deep Malware Scan');
    expect(invoice.services.single.addons.single.price, 29);
    expect(invoice.services.single.amount, 69);
    expect(invoice.totals.balanceDue, 0);
    expect(
      invoice.download.url,
      '/api/bookings/6ac03587fdc24f879a9a783c/invoice',
    );
    expect(invoice.download.contentType, 'text/plain');
    expect(invoice.download.filename, 'invoice-6ac03587fdc24f879a9a783c.txt');
  });

  test('uses details URL to download authenticated invoice bytes', () async {
    final client = _RecordingDioClient();
    final repo = ApiRepo(client);
    final invoice = await repo.getBookingInvoice('6ac03587fdc24f879a9a783c');
    final bytes = await repo.downloadBookingInvoice(
      bookingId: invoice.bookingId,
      downloadUrl: invoice.download.url,
    );

    expect(client.paths, [
      '/api/bookings/6ac03587fdc24f879a9a783c/invoice/details',
      '${ApiEndpoints.baseUrl}/api/bookings/6ac03587fdc24f879a9a783c/invoice',
    ]);
    expect(client.optionsSeen.last?.responseType, dio.ResponseType.bytes);
    expect(String.fromCharCodes(bytes), 'invoice text');
    expect(
      invoice.download.url,
      '/api/bookings/6ac03587fdc24f879a9a783c/invoice',
    );
  });

  testWidgets('renders invoice sections at a narrow screen width', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.put<ApiRepo>(_InvoiceRepo());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: InvoiceScreen(bookingId: '6ac03587fdc24f879a9a783c'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('INVOICE'), findsOneWidget);
    expect(find.text('BILL TO'), findsOneWidget);
    expect(find.text('SERVICES ORDERED'), findsOneWidget);
    expect(find.text('CUSTOMER DETAILS'), findsOneWidget);
    expect(find.text('TERMS OF SERVICE'), findsOneWidget);
    expect(find.text('Mayank'), findsWidgets);
    expect(find.textContaining('PC Virus Removal'), findsOneWidget);
    expect(find.textContaining('Basic Virus Scan & Removal'), findsOneWidget);
    expect(find.textContaining('Deep Malware Scan'), findsOneWidget);
    expect(find.textContaining('\$69.00'), findsWidgets);
    expect(find.byTooltip('Download invoice'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('booking invoice entry opens the invoice preview', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<ApiRepo>(_InvoiceRepo());
    final booking = BookingHistoryItem.fromJson({
      '_id': '6ac03587fdc24f879a9a783c',
      'services': [
        {
          'service': {'name': 'PC Diagnosis'},
        },
      ],
    });

    await tester.pumpWidget(
      GetMaterialApp(home: BookingDetailsScreen(booking: booking)),
    );
    await tester.tap(find.text('View and download your invoice'));
    await tester.pumpAndSettle();

    expect(find.byType(InvoiceScreen), findsOneWidget);
    expect(find.text('INV-9A9A783C'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
