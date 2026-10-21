import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/booking_invoice_model.dart';
import 'widgets/booking_ui.dart';

class InvoiceScreen extends StatefulWidget {
  final String bookingId;

  const InvoiceScreen({super.key, required this.bookingId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  static const _line = Color(0xFFE2E2E2);
  static const _sectionHeaderColor = Color(0xFFE9E9E9);
  final _terms = <_InvoiceTerm>[];
  BookingInvoice? _invoice;
  String? _error;
  bool _isLoading = true;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
    _loadTerms();
  }

  Future<void> _loadInvoice() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final invoice = await Get.find<ApiRepo>().getBookingInvoice(
        widget.bookingId,
      );
      if (!mounted) return;
      setState(() {
        _invoice = invoice;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = _invoiceErrorMessage(error);
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadInvoice() async {
    final invoice = _invoice;

    if (invoice == null || invoice.download.url.trim().isEmpty) {
      _showMessage('Invoice URL is unavailable.', error: true);
      return;
    }

    try {
      final url = invoice.download.url.trim();

      final fullUrl = url.startsWith('http')
          ? url
          : 'http://192.168.1.72:5001$url';

      final uri = Uri.parse(fullUrl);

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage('Unable to open invoice.', error: true);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(_invoiceErrorMessage(error), error: true);
      }
    }
  }

  void _showMessage(String message, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text((message).tr),
          backgroundColor: error ? const Color(0xFFA83B3B) : bookingInk,
        ),
      );
  }

  Future<void> _loadTerms() async {
    try {
      final source = await rootBundle.loadString(
        'assets/html/terms_conditions.html',
      );
      final elements = html_parser
          .parse(source)
          .body
          ?.querySelectorAll('h2, h3, p, li');
      if (!mounted || elements == null) return;
      setState(() {
        _terms
          ..clear()
          ..addAll(
            elements
                .map((element) {
                  final text = element.text
                      .replaceAll(RegExp(r'\s+'), ' ')
                      .trim();
                  return _InvoiceTerm(
                    text: text,
                    heading:
                        element.localName == 'h2' || element.localName == 'h3',
                  );
                })
                .where((term) => term.text.isNotEmpty),
          );
      });
    } catch (error) {
      debugPrint('Unable to load invoice terms: $error');
    }
  }

  String _invoiceErrorMessage(Object error) {
    if (error is ApiException) return error.message;
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) return 'Unable to load invoice ($statusCode).';
      return error.message ?? 'Unable to load the invoice. Please try again.';
    }
    final message = error.toString();
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }

  String _customerAddress(InvoiceAddress address) {
    if (address.formatted.isNotEmpty) return address.formatted;
    return [
      address.addressLine,
      address.city,
      address.state,
      address.zipcode,
    ].where((part) => part.isNotEmpty).join(', ');
  }

  String _date(DateTime? date) {
    if (date == null) return '—';
    return DateFormat.yMMMMd(
      Get.locale?.toLanguageTag() ?? 'en-US',
    ).format(date.toUtc());
  }

  String _money(num value) {
    final currency = switch (_invoice?.currency.toUpperCase()) {
      'USD' => r'$',
      'INR' => '₹',
      'EUR' => '€',
      'GBP' => '£',
      final code when code != null && code.isNotEmpty => '$code ',
      _ => '',
    };
    return '$currency${value.toStringAsFixed(2)}';
  }

  String _quantity(num value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  Widget _sectionHeader(String title, IconData icon) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    color: _sectionHeaderColor,
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          (title).tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );

  Widget _dataTable({
    required List<List<String>> rows,
    List<double>? columnFlex,
  }) {
    final flex = columnFlex ?? const [2.5, 5.0];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        columnWidths: {
          for (var i = 0; i < flex.length; i++) i: FlexColumnWidth(flex[i]),
        },
        border: const TableBorder(
          horizontalInside: BorderSide(color: _line),
          verticalInside: BorderSide(color: _line),
        ),
        children: [
          for (final row in rows)
            TableRow(
              children: [
                for (var i = 0; i < row.length; i++)
                  _tableCell(row[i], label: i == 0),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tableCell(String value, {bool label = false}) => Container(
    width: double.infinity,
    color: label ? const Color(0xFFF7F7F7) : Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
    child: Text(
      (value.isEmpty ? '—' : value).tr,
      style: TextStyle(
        color: label ? bookingMuted : bookingInk,
        fontSize: 10,
        height: 1.35,
        fontWeight: label ? FontWeight.w700 : FontWeight.w500,
      ),
    ),
  );

  Widget _invoiceMetaTable(BookingInvoice invoice) => _dataTable(
    rows: [
      ['Invoice Number', invoice.invoiceNumber],
      ['Invoice Date', _date(invoice.invoiceDate)],
      ['Booking ID', invoice.bookingId],
      ['Scheduled Date', _date(invoice.scheduledDate)],
      ['Status', invoice.status],
      ['Payment Status', invoice.paymentStatus],
    ],
  );

  Widget _customerTable(BookingInvoice invoice, String address) => _dataTable(
    rows: [
      [
        'Name',
        invoice.customer.name.isEmpty ? 'Customer' : invoice.customer.name,
      ],
      ['Phone Number', invoice.customer.phone],
      ['Email', invoice.customer.email],
      ['Location', address],
    ],
  );

  Widget _totalsTable(BookingInvoice invoice) {
    final rows = <TableRow>[
      _totalTableRow('Subtotal', _money(invoice.totals.subtotal)),
    ];

    if (invoice.totals.adjustments != 0) {
      rows.add(
        _totalTableRow('Adjustments', _money(invoice.totals.adjustments)),
      );
    }

    rows.addAll([
      _totalTableRow(
        'Total Amount',
        _money(invoice.totals.totalAmount),
        strong: true,
        background: _sectionHeaderColor,
      ),
      _totalTableRow('Paid Amount', _money(invoice.totals.paidAmount)),
      _totalTableRow(
        'Balance Due',
        _money(invoice.totals.balanceDue),
        strong: true,
        background: const Color(0xFFF3F3F3),
      ),
    ]);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(2)},
        border: const TableBorder(
          horizontalInside: BorderSide(color: _line),
          verticalInside: BorderSide(color: _line),
        ),
        children: rows,
      ),
    );
  }

  TableRow _totalTableRow(
    String label,
    String value, {
    bool strong = false,
    Color? background,
  }) => TableRow(
    children: [
      Container(
        color: background ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Text(
          (label).tr,
          style: TextStyle(
            color: bookingInk,
            fontSize: 11,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
      Container(
        color: background ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Text(
          (value).tr,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: bookingInk,
            fontSize: 11,
            fontWeight: strong ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _serviceTable(BookingInvoice invoice, double width) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Table(
            columnWidths: const {
              0: FlexColumnWidth(0.55),
              1: FlexColumnWidth(3.8),
              2: FlexColumnWidth(0.8),
              3: FlexColumnWidth(1.35),
              4: FlexColumnWidth(1.35),
            },
            border: const TableBorder(
              horizontalInside: BorderSide(color: _line),
              verticalInside: BorderSide(color: _line),
            ),
            children: [
              _serviceHeaderRow(),
              for (final service in invoice.services) _serviceDataRow(service),
              if (invoice.services.isEmpty)
                TableRow(
                  children: [
                    SizedBox.shrink(),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "No service lines are available.".tr,
                        style: TextStyle(color: bookingMuted, fontSize: 10),
                      ),
                    ),
                    SizedBox.shrink(),
                    SizedBox.shrink(),
                    SizedBox.shrink(),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  TableRow _serviceHeaderRow() => TableRow(
    decoration: const BoxDecoration(color: Color(0xFFF7F7F7)),
    children: [
      _serviceTableCell('#', header: true, center: true),
      _serviceTableCell('Service Name', header: true),
      _serviceTableCell('Qty', header: true, center: true),
      _serviceTableCell('Unit Price', header: true, center: true),
      _serviceTableCell('Amount', header: true, center: true),
    ],
  );

  TableRow _serviceDataRow(dynamic service) => TableRow(
    children: [
      _serviceTableCell('${service.lineNumber}', center: true),
      _serviceTableCell(
        [
          service.name,
          if (service.variantName.isNotEmpty) service.variantName,
          if (service.addons.isNotEmpty)
            'Add-ons: ${service.addons.map((addon) => addon.name).join(', ')}',
        ].join('\n'),
      ),
      _serviceTableCell('x${_quantity(service.quantity)}', center: true),
      _serviceTableCell(_money(service.unitPrice), center: true),
      _serviceTableCell(_money(service.amount), center: true),
    ],
  );

  Widget _serviceTableCell(
    String text, {
    bool header = false,
    bool center = false,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
    alignment: center ? Alignment.center : Alignment.centerLeft,
    child: Text(
      (text).tr,
      textAlign: center ? TextAlign.center : TextAlign.start,
      softWrap: true,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 9,
        height: 1.35,
        fontWeight: header ? FontWeight.w700 : FontWeight.w400,
      ),
    ),
  );

  Widget _termsContent(double width) {
    if (_terms.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Text(
          "Terms of Service are available in the app’s Terms & Conditions.".tr,
          style: TextStyle(color: bookingMuted, fontSize: 10),
        ),
      );
    }
    final columns = width >= 640 ? 2 : 1;
    final split = (_terms.length / columns).ceil();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var column = 0; column < columns; column++) ...[
            if (column > 0) const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final term in _terms.skip(column * split).take(split))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text(
                        (term.heading ? term.text : '•  ${term.text}').tr,
                        style: TextStyle(
                          color: bookingInk,
                          fontSize: 9,
                          height: 1.35,
                          fontWeight: term.heading
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final invoice = _invoice;
    return Scaffold(
      backgroundColor: bookingBackground,
      appBar: AppBar(
        title: Text(
          "Invoice".tr,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Download invoice".tr,
            onPressed: _isDownloading || invoice == null
                ? null
                : _downloadInvoice,
            icon: _isDownloading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: bookingInk),
                  )
                : _error != null
                ? _loadError()
                : invoice == null
                ? _loadError()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: _line),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 12,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: _invoiceBody(invoice),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _loadError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 42,
            color: bookingMuted,
          ),
          const SizedBox(height: 12),
          Text(
            (_error ?? "Invoice details are unavailable.".tr).tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: bookingMuted),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _loadInvoice,
            icon: const Icon(Icons.refresh),
            label: Text("Try again".tr),
          ),
        ],
      ),
    ),
  );

  Widget _invoiceBody(BookingInvoice invoice) => LayoutBuilder(
    builder: (context, constraints) {
      final address = _customerAddress(invoice.customer.address);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice header table.
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(3),
              },
              border: const TableBorder(
                verticalInside: BorderSide(color: _line),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ('SOS').tr,
                                  /*invoice.company.name.isEmpty
                                      ? 'APP'
                                      : invoice.company.name*/
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (invoice.company.website.isNotEmpty)
                            _headerInfoRow('Website', invoice.company.website),
                          if (invoice.company.phone.isNotEmpty)
                            _headerInfoRow('Phone', invoice.company.phone),
                          if (invoice.company.email.isNotEmpty)
                            _headerInfoRow('Email', invoice.company.email),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "INVOICE".tr,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            ('# ${invoice.invoiceNumber}').tr,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: bookingInk,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Billing and invoice metadata tables.
          _sectionHeader('BILL TO', Icons.person_outline),
          _customerTable(invoice, address),
          const SizedBox(height: 14),
          _sectionHeader('INVOICE DETAILS', Icons.receipt_long_outlined),
          _invoiceMetaTable(invoice),
          const SizedBox(height: 16),

          // Services table.
          _sectionHeader('SERVICES ORDERED', Icons.handyman_outlined),
          _serviceTable(invoice, constraints.maxWidth),
          const SizedBox(height: 14),

          // Totals table.
          _sectionHeader('PAYMENT SUMMARY', Icons.payments_outlined),
          _totalsTable(invoice),
          const SizedBox(height: 18),

          // Terms.
          _sectionHeader('TERMS OF SERVICE', Icons.description_outlined),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _termsContent(constraints.maxWidth),
          ),
          const SizedBox(height: 18),

          // Footer table.
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(3),
              },
              border: const TableBorder(
                verticalInside: BorderSide(color: _line),
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Thank you for choosing us!".tr,
                            style: TextStyle(
                              color: bookingInk,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "All services, one app.".tr,
                            style: TextStyle(color: bookingMuted, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        (invoice.currency.isEmpty
                                ? ''
                                : "All fees are listed in @p0.".trParams({
                                    "p0": (invoice.currency).toString(),
                                  }))
                            .tr,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: bookingMuted,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );

  Widget _headerInfoRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 52,
          child: Text(
            (label).tr,
            style: const TextStyle(
              color: bookingMuted,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text((':').tr, style: TextStyle(color: bookingMuted, fontSize: 9)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            (value).tr,
            style: const TextStyle(color: bookingInk, fontSize: 9),
          ),
        ),
      ],
    ),
  );
}

class _InvoiceTerm {
  final String text;
  final bool heading;

  const _InvoiceTerm({required this.text, required this.heading});
}
