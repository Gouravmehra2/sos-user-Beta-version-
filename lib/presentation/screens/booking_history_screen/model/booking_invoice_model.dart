class BookingInvoice {
  final String invoiceNumber;
  final String bookingId;
  final DateTime? invoiceDate;
  final DateTime? scheduledDate;
  final String status;
  final String paymentStatus;
  final String currency;
  final InvoiceCompany company;
  final InvoiceCustomer customer;
  final List<InvoiceService> services;
  final InvoiceTotals totals;
  final InvoiceDownload download;

  const BookingInvoice({
    required this.invoiceNumber,
    required this.bookingId,
    required this.invoiceDate,
    required this.scheduledDate,
    required this.status,
    required this.paymentStatus,
    required this.currency,
    required this.company,
    required this.customer,
    required this.services,
    required this.totals,
    required this.download,
  });

  factory BookingInvoice.fromJson(Map<String, dynamic> json) {
    final id = _invoiceString(json['bookingId']);
    final number = _invoiceString(json['invoiceNumber']);
    return BookingInvoice(
      invoiceNumber: number.isNotEmpty
          ? number
          : 'INV-${id.length > 8 ? id.substring(id.length - 8) : id}'
                .toUpperCase(),
      bookingId: id,
      invoiceDate: _invoiceDate(json['invoiceDate']),
      scheduledDate: _invoiceDate(json['scheduledDate']),
      status: _invoiceString(json['status']),
      paymentStatus: _invoiceString(json['paymentStatus']),
      currency: _invoiceString(json['currency']),
      company: InvoiceCompany.fromJson(_invoiceMap(json['company'])),
      customer: InvoiceCustomer.fromJson(_invoiceMap(json['customer'])),
      services: _invoiceList(
        json['services'],
      ).whereType<Map<String, dynamic>>().map(InvoiceService.fromJson).toList(),
      totals: InvoiceTotals.fromJson(_invoiceMap(json['totals'])),
      download: InvoiceDownload.fromJson(_invoiceMap(json['download'])),
    );
  }
}

class InvoiceCompany {
  final String name;
  final String website;
  final String email;
  final String phone;

  const InvoiceCompany({
    required this.name,
    required this.website,
    required this.email,
    required this.phone,
  });

  factory InvoiceCompany.fromJson(Map<String, dynamic> json) => InvoiceCompany(
    name: _invoiceString(json['name']),
    website: _invoiceString(json['website']),
    email: _invoiceString(json['email']),
    phone: _invoiceString(json['phone']),
  );
}

class InvoiceCustomer {
  final String name;
  final String email;
  final String phone;
  final InvoiceAddress address;

  const InvoiceCustomer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory InvoiceCustomer.fromJson(Map<String, dynamic> json) =>
      InvoiceCustomer(
        name: _invoiceString(json['name']),
        email: _invoiceString(json['email']),
        phone: _invoiceString(json['phone']),
        address: InvoiceAddress.fromJson(_invoiceMap(json['address'])),
      );
}

class InvoiceAddress {
  final String addressLine;
  final String city;
  final String state;
  final String zipcode;
  final String formatted;

  const InvoiceAddress({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.formatted,
  });

  factory InvoiceAddress.fromJson(Map<String, dynamic> json) => InvoiceAddress(
    addressLine: _invoiceString(json['addressLine']),
    city: _invoiceString(json['city']),
    state: _invoiceString(json['state']),
    zipcode: _invoiceString(json['zipcode']),
    formatted: _invoiceString(json['formatted']),
  );
}

class InvoiceService {
  final int lineNumber;
  final String? serviceId;
  final String name;
  final String variantName;
  final List<InvoiceAddon> addons;
  final num quantity;
  final num unitPrice;
  final num amount;

  const InvoiceService({
    required this.lineNumber,
    required this.serviceId,
    required this.name,
    required this.variantName,
    required this.addons,
    required this.quantity,
    required this.unitPrice,
    required this.amount,
  });

  factory InvoiceService.fromJson(Map<String, dynamic> json) => InvoiceService(
    lineNumber: _invoiceNumber(json['lineNumber']).toInt(),
    serviceId: json['serviceId'] is String ? json['serviceId'] as String : null,
    name: _invoiceString(json['name']),
    variantName: _invoiceString(json['variantName']),
    addons: _invoiceList(
      json['addons'],
    ).whereType<Map<String, dynamic>>().map(InvoiceAddon.fromJson).toList(),
    quantity: _invoiceNumber(json['quantity']),
    unitPrice: _invoiceNumber(json['unitPrice']),
    amount: _invoiceNumber(json['amount']),
  );
}

class InvoiceAddon {
  final String name;
  final num price;

  const InvoiceAddon({required this.name, required this.price});

  factory InvoiceAddon.fromJson(Map<String, dynamic> json) => InvoiceAddon(
    name: _invoiceString(json['name']),
    price: _invoiceNumber(json['price']),
  );
}

class InvoiceTotals {
  final num subtotal;
  final num adjustments;
  final num totalAmount;
  final num paidAmount;
  final num balanceDue;

  const InvoiceTotals({
    required this.subtotal,
    required this.adjustments,
    required this.totalAmount,
    required this.paidAmount,
    required this.balanceDue,
  });

  factory InvoiceTotals.fromJson(Map<String, dynamic> json) => InvoiceTotals(
    subtotal: _invoiceNumber(json['subtotal']),
    adjustments: _invoiceNumber(json['adjustments']),
    totalAmount: _invoiceNumber(json['totalAmount']),
    paidAmount: _invoiceNumber(json['paidAmount']),
    balanceDue: _invoiceNumber(json['balanceDue']),
  );
}

class InvoiceDownload {
  final String url;
  final String contentType;
  final String filename;

  const InvoiceDownload({
    required this.url,
    required this.contentType,
    required this.filename,
  });

  factory InvoiceDownload.fromJson(Map<String, dynamic> json) =>
      InvoiceDownload(
        url: _invoiceString(json['url']),
        contentType: _invoiceString(json['contentType']),
        filename: _invoiceString(json['filename']),
      );
}

Map<String, dynamic> _invoiceMap(dynamic value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

List<dynamic> _invoiceList(dynamic value) =>
    value is List<dynamic> ? value : <dynamic>[];

String _invoiceString(dynamic value) => value is String ? value : '';

num _invoiceNumber(dynamic value) => value is num ? value : 0;

DateTime? _invoiceDate(dynamic value) =>
    value is String ? DateTime.tryParse(value)?.toUtc() : null;
