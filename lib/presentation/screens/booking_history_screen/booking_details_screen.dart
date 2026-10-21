import 'package:flutter/material.dart';
import 'model/booking_history_model.dart';
import 'invoice_screen.dart';
import 'widgets/booking_ui.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingHistoryItem booking;
  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final payment = booking.paymentDetails;
    final technician = booking.assignedTechnician;
    return Scaffold(
      backgroundColor: bookingBackground,
      appBar: AppBar(
        title: const Text(
          'Booking details',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.black,
        foregroundColor: bookingInk,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
              key: const ValueKey('booking-details-scroll'),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookingPanel(
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          BookingStatus(booking.status),
                          BookingStatus(booking.paymentStatus),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        bookingTitle(booking),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: bookingInk,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BookingValue(
                        'Booking ID',
                        booking.id.isEmpty ? 'Not available' : booking.id,
                        selectable: true,
                      ),
                      const Divider(color: bookingBorder, height: 20),
                      const Text(
                        'Booking total',
                        style: TextStyle(color: bookingMuted, fontSize: 13),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        bookingMoney(booking.totalAmount),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: bookingInk,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _AdditionalItems(services: booking.services),
                      const SizedBox(height: 14),
                      _InvoiceLink(bookingId: booking.id),
                    ],
                  ),
                  BookingPanel(
                    title: 'Schedule & location',
                    icon: Icons.event_outlined,
                    children: [
                      BookingValue(
                        'Service date',
                        bookingDate(booking.serviceDate),
                      ),
                      const Divider(color: bookingBorder, height: 20),
                      Text(
                        booking.address.label.isEmpty
                            ? 'Service address'
                            : booking.address.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: bookingInk,
                        ),
                      ),
                      if (booking.address.name.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(booking.address.name),
                      ],
                      BookingInfo(
                        icon: Icons.location_on_outlined,
                        text: bookingAddress(booking.address),
                      ),
                      if (booking.phone.isNotEmpty)
                        BookingInfo(
                          icon: Icons.phone_outlined,
                          text: booking.phone,
                        ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(2, 8, 0, 14),
                    child: Text(
                      'Booked services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: bookingInk,
                      ),
                    ),
                  ),
                  if (booking.services.isEmpty)
                    const BookingPanel(
                      children: [Text('Service details are not available.')],
                    ),
                  for (final item in booking.services)
                    _ServicePanel(item: item),
                  BookingPanel(
                    title: 'Your technician',
                    icon: Icons.person_outline,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: bookingBackground,
                            foregroundColor: bookingInk,
                            child: technician.name.isEmpty
                                ? const Icon(Icons.person_outline)
                                : Text(
                                    technician.name.characters.first
                                        .toUpperCase(),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  technician.name.isEmpty
                                      ? 'Technician not assigned'
                                      : technician.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: bookingInk,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                if (technician.phone.isNotEmpty)
                                  SelectableText(
                                    technician.phone,
                                    style: const TextStyle(color: bookingMuted),
                                  )
                                else
                                  Text(
                                    technician.name.isEmpty
                                        ? 'Assignment details will appear here when available.'
                                        : 'Contact number not available',
                                    style: const TextStyle(
                                      color: bookingMuted,
                                      height: 1.5,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (booking.specialInstructions.trim().isNotEmpty)
                    BookingPanel(
                      title: 'Special instructions',
                      icon: Icons.notes_rounded,
                      children: [
                        Text(
                          booking.specialInstructions,
                          style: const TextStyle(
                            color: bookingMuted,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  BookingPanel(
                    title: 'Payment details',
                    icon: Icons.account_balance_wallet_outlined,
                    children: [
                      BookingStatus(booking.paymentStatus),
                      const SizedBox(height: 16),
                      BookingValue(
                        'Total amount',
                        bookingMoney(booking.totalAmount),
                      ),
                      if (payment.provider.isNotEmpty)
                        BookingValue('Payment provider', payment.provider),
                      if (payment.orderId.isNotEmpty ||
                          payment.paymentId.isNotEmpty ||
                          payment.transactionId.isNotEmpty)
                        const Divider(color: bookingBorder, height: 24),
                      if (payment.orderId.isNotEmpty)
                        BookingValue(
                          'Order ID',
                          payment.orderId,
                          selectable: true,
                        ),
                      if (payment.paymentId.isNotEmpty)
                        BookingValue(
                          'Payment ID',
                          payment.paymentId,
                          selectable: true,
                        ),
                      if (payment.transactionId.isNotEmpty)
                        BookingValue(
                          'Transaction ID',
                          payment.transactionId,
                          selectable: true,
                        ),
                    ],
                  ),
                  if (booking.createdAt != null || booking.updatedAt != null)
                    BookingPanel(
                      title: 'Booking activity',
                      icon: Icons.history_rounded,
                      children: [
                        if (booking.createdAt != null)
                          BookingValue(
                            'Booked on',
                            bookingDate(booking.createdAt, time: true),
                          ),
                        if (booking.updatedAt != null)
                          BookingValue(
                            'Last updated',
                            bookingDate(booking.updatedAt, time: true),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InvoiceLink extends StatelessWidget {
  final String bookingId;
  const _InvoiceLink({required this.bookingId});

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xFFF7F8F8),
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: bookingId.isEmpty
          ? null
          : () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => InvoiceScreen(bookingId: bookingId),
              ),
            ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: bookingBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.receipt_long_outlined, color: bookingInk),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice',
                    style: TextStyle(
                      color: bookingInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'View and download your invoice',
                    style: TextStyle(color: bookingMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: bookingMuted),
          ],
        ),
      ),
    ),
  );
}

class _ServicePanel extends StatelessWidget {
  final BookingService item;
  const _ServicePanel({required this.item});
  @override
  Widget build(BuildContext context) {
    final service = item.service;
    final duration = service.serviceDuration > 0
        ? service.serviceDuration
        : service.duration;
    final description = service.longDescription.isNotEmpty
        ? service.longDescription
        : service.description;
    final steps = [...service.processSteps]
      ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
    final faqs = [...service.faqs]..sort((a, b) => a.order.compareTo(b.order));
    return BookingPanel(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingImage(service.featuredImage, size: 64),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name.isEmpty ? 'Service' : service.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: bookingInk,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Quantity: ${item.quantity}',
                    style: const TextStyle(color: bookingMuted, fontSize: 13),
                  ),
                  if (duration > 0)
                    Text(
                      '$duration min per service',
                      style: const TextStyle(color: bookingMuted, fontSize: 13),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BookingValue('Booked price', bookingMoney(item.price)),
        if (item.variantName.isNotEmpty)
          BookingValue('Selected variant', item.variantName),
        if (description.isNotEmpty ||
            service.shortDescription.isNotEmpty ||
            service.includedItems.isNotEmpty ||
            service.excludedItems.isNotEmpty ||
            service.requirements.isNotEmpty ||
            steps.isNotEmpty ||
            faqs.isNotEmpty ||
            service.tools.isNotEmpty)
          Material(
            color: Colors.white,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                title: const Text(
                  'Service information',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                children: [
                  if (description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: bookingMuted,
                          height: 1.6,
                        ),
                      ),
                    ),
                  if (description.isEmpty)
                    for (final line in service.shortDescription)
                      BookingInfo(icon: Icons.check, text: line),
                  _ServiceList(
                    title: 'What’s included',
                    entries: service.includedItems.map((e) => e.title).toList(),
                    icon: Icons.check_circle_outline,
                  ),
                  _ServiceList(
                    title: 'Not included',
                    entries: service.excludedItems.map((e) => e.title).toList(),
                    icon: Icons.remove_circle_outline,
                  ),
                  _ServiceList(
                    title: 'Before your service',
                    entries: service.requirements.map((e) => e.title).toList(),
                    icon: Icons.task_alt,
                  ),
                  _ServiceList(
                    title: 'Tools & equipment',
                    entries: service.tools
                        .map(
                          (e) => [
                            e.name,
                            e.description,
                          ].where((s) => s.isNotEmpty).join(' — '),
                        )
                        .toList(),
                    icon: Icons.build_outlined,
                  ),
                  if (steps.isNotEmpty) ...[
                    const _Subheading('How it works'),
                    for (final step in steps)
                      BookingValue(
                        '${step.stepNumber}. ${step.title}',
                        step.description,
                      ),
                  ],
                  if (faqs.isNotEmpty) ...[
                    const _Subheading('Frequently asked questions'),
                    for (final faq in faqs)
                      ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text(
                          faq.question,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                faq.answer,
                                style: const TextStyle(
                                  color: bookingMuted,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _AdditionalItems extends StatelessWidget {
  final List<BookingService> services;
  const _AdditionalItems({required this.services});

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final service in services)
        for (final selected in service.selectedAddons)
          _AdditionalItem.fromSelection(selected, service),
    ];
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8F7),
        border: Border.all(color: bookingBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle_outline, size: 18, color: bookingInk),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Additional items',
                  style: TextStyle(
                    color: bookingInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${items.length}',
                style: const TextStyle(
                  color: bookingMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: 16, color: bookingBorder),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[index].name,
                        style: const TextStyle(
                          color: bookingInk,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (items[index].serviceName.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          items[index].serviceName,
                          style: const TextStyle(
                            color: bookingMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (items[index].price != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    bookingMoney(items[index].price!),
                    style: const TextStyle(
                      color: bookingInk,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AdditionalItem {
  final String name;
  final String serviceName;
  final num? price;

  const _AdditionalItem({
    required this.name,
    required this.serviceName,
    required this.price,
  });

  factory _AdditionalItem.fromSelection(
    dynamic selected,
    BookingService bookingService,
  ) {
    var name = '';
    var id = '';
    num? price;
    if (selected is String) {
      id = selected;
      name = selected;
    } else if (selected is Map) {
      final rawName = selected['name'] ?? selected['addonName'];
      if (rawName is String) name = rawName;
      final rawId =
          selected['addonId'] ??
          selected['addon'] ??
          selected['_id'] ??
          selected['id'];
      if (rawId is String) id = rawId;
      final rawPrice = selected['price'];
      if (rawPrice is num) price = rawPrice;
    }

    BookingAddon? catalogItem;
    for (final addon in bookingService.service.addons) {
      if ((id.isNotEmpty && addon.id == id) ||
          (name.isNotEmpty && addon.name.toLowerCase() == name.toLowerCase())) {
        catalogItem = addon;
        break;
      }
    }
    if (catalogItem != null) {
      name = catalogItem.name;
      price ??= catalogItem.price;
    }
    if (name.isEmpty || (selected is String && name == selected)) {
      name = catalogItem?.name ?? 'Selected add-on';
    }

    return _AdditionalItem(
      name: name,
      serviceName: bookingService.service.name,
      price: price,
    );
  }
}

class _Subheading extends StatelessWidget {
  final String text;
  const _Subheading(this.text);
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(color: bookingInk, fontWeight: FontWeight.w700),
      ),
    ),
  );
}

class _ServiceList extends StatelessWidget {
  final String title;
  final List<String> entries;
  final IconData icon;
  const _ServiceList({
    required this.title,
    required this.entries,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) => entries.isEmpty
      ? const SizedBox.shrink()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Subheading(title),
            for (final entry in entries) BookingInfo(icon: icon, text: entry),
          ],
        );
}
