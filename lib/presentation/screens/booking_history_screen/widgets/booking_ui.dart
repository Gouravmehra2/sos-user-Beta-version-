import 'package:intl/intl.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';
import 'package:squadonsite/constant/common_widgets/app_network_image.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import '../model/booking_history_model.dart';

const bookingInk = Color(0xFF182025);
const bookingMuted = Color(0xFF69747A);
const bookingBackground = Color(0xFFF4F6F7);
const bookingBorder = Color(0xFFE6EBED);

String bookingMoney(num amount) => '\$${amount.toStringAsFixed(2)}';
String bookingAddress(BookingAddress address) {
  final parts = [
    address.addressLine,
    address.city,
    address.state,
    address.zipcode,
  ].where((part) => part.trim().isNotEmpty);
  return parts.isEmpty ? 'Address not provided'.tr : parts.join(', ');
}

String bookingDate(DateTime? date, {bool time = false}) {
  if (date == null) return 'Date to be confirmed'.tr;
  final local = date.toLocal();
  final locale = Get.locale?.toLanguageTag() ?? 'en-US';
  final day = DateFormat.yMMMd(locale).format(local);
  return time ? '$day · ${DateFormat.jm(locale).format(local)}' : day;
}

String bookingTitle(BookingHistoryItem booking) {
  final names = booking.services
      .map((item) => item.service.name)
      .where((name) => name.trim().isNotEmpty)
      .toList();
  return names.isEmpty ? 'Service booking'.tr : names.join(', ');
}

class BookingStatus extends StatelessWidget {
  final String status;
  const BookingStatus(this.status, {super.key});
  @override
  Widget build(BuildContext context) {
    final value = status.trim().toLowerCase();
    final color = switch (value) {
      'paid' || 'completed' || 'confirmed' => const Color(0xFF21684D),
      'cancelled' || 'canceled' || 'failed' => const Color(0xFFA83B3B),
      'pending' || 'unpaid' => const Color(0xFF8A611C),
      'in progress' || 'in_progress' || 'ongoing' => const Color(0xFF2C6093),
      _ => bookingMuted,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        (status.isEmpty ? "Not available".tr : status).tr,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BookingImage extends StatelessWidget {
  final String path;
  final double size;
  const BookingImage(this.path, {super.key, this.size = 60});
  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bookingBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.home_repair_service_outlined,
        color: bookingMuted,
      ),
    );
    if (path.isEmpty) return fallback;
    final url = path.startsWith('https://') || path.startsWith('http://')
        ? path
        : '${ApiEndpoints.imageUrl}${path.replaceFirst(RegExp(r'^/+'), '')}';
    return AppNetworkImage(
      url: url,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(14),
      placeholder: fallback,
      errorWidget: fallback,
    );
  }
}

class BookingPanel extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final List<Widget> children;
  const BookingPanel({
    super.key,
    this.title,
    this.icon,
    required this.children,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: bookingBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 19, color: bookingInk),
                const SizedBox(width: 9),
              ],
              Expanded(
                child: Text(
                  (title!).tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: bookingInk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
        ],
        ...children,
      ],
    ),
  );
}

class BookingInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const BookingInfo({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: bookingMuted),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            (text).tr,
            style: const TextStyle(
              color: bookingMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}

class BookingValue extends StatelessWidget {
  final String label;
  final String value;
  final bool selectable;
  const BookingValue(
    this.label,
    this.value, {
    super.key,
    this.selectable = false,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (label).tr,
          style: const TextStyle(color: bookingMuted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        if (selectable)
          SelectableText(
            (value).tr,
            style: const TextStyle(
              color: bookingInk,
              fontSize: 14,
              height: 1.4,
            ),
          )
        else
          Text(
            (value).tr,
            style: const TextStyle(
              color: bookingInk,
              fontSize: 14,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    ),
  );
}
