import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'booking_history_controller.dart';
import 'booking_details_screen.dart';
import 'model/booking_history_model.dart';
import 'widgets/booking_ui.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen>
    with SingleTickerProviderStateMixin {
  static const _filters = [
    'All',
    'Completed',
    'Pending',
    'Confirmed',
    'Cancelled',
  ];
  final _searches = List.generate(
    _filters.length,
    (_) => TextEditingController(),
  );
  final _queries = List.filled(_filters.length, '');
  late final TabController _tabController;
  int _activeTab = 0;

  BookingHistoryController get controller =>
      Get.find<BookingHistoryController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final search in _searches) {
      search.dispose();
    }
    super.dispose();
  }

  void _requestFilter({bool debounce = false}) {
    controller.applyFilter(
      _activeTab == 0 ? 'all' : _filters[_activeTab],
      _queries[_activeTab],
      debounce: debounce,
    );
  }

  void _clearFilters() {
    for (final search in _searches) {
      search.clear();
    }
    for (var index = 0; index < _queries.length; index++) {
      _queries[index] = '';
    }
    setState(() {
      _activeTab = 0;
      _tabController.index = 0;
    });
    _requestFilter();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: bookingBackground,
    appBar: AppBar(
      title: Text(
        "My bookings".tr,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      bottom: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() => _activeTab = index);
          _requestFilter();
        },
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.white,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 2),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        tabs: [for (final filter in _filters) Tab(text: (filter).tr)],
      ),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Obx(() {
            final bookings = controller.bookings.toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        key: ValueKey('booking-search-$_activeTab'),
                        controller: _searches[_activeTab],
                        onChanged: (value) {
                          setState(() => _queries[_activeTab] = value);
                          _requestFilter(debounce: true);
                        },
                        decoration: InputDecoration(
                          hintText: "Search services, ID or location".tr,
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: bookingMuted,
                          ),
                          suffixIcon: _queries[_activeTab].isEmpty
                              ? null
                              : IconButton(
                                  tooltip: "Clear search".tr,
                                  onPressed: () => setState(() {
                                    _searches[_activeTab].clear();
                                    _queries[_activeTab] = '';
                                    _requestFilter();
                                  }),
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: bookingBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: bookingBorder),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isLoading.value)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: bookingInk,
                    backgroundColor: bookingBorder,
                  ),
                if (controller.errorMessage.value.isNotEmpty &&
                    controller.bookings.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            (controller.errorMessage.value).tr,
                            style: const TextStyle(color: bookingMuted),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.fetchBookings,
                          child: Text("Retry".tr),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchBookings,
                    color: bookingInk,
                    child: bookings.isEmpty
                        ? LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              controller: controller.scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: _EmptyBookings(
                                    loading: controller.isLoading.value,
                                    error: controller.bookings.isEmpty
                                        ? controller.errorMessage.value
                                        : '',
                                    filtered:
                                        _queries[_activeTab].isNotEmpty ||
                                        _activeTab != 0,
                                    retry: controller.fetchBookings,
                                    clear: _clearFilters,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                            itemCount:
                                bookings.length +
                                (controller.isLoadingMore.value ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == bookings.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return _BookingCard(booking: bookings[index]);
                            },
                          ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ),
  );
}

class _BookingCard extends StatefulWidget {
  final BookingHistoryItem booking;

  const _BookingCard({required this.booking});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  int? _serviceRating;
  int? _technicianRating;

  @override
  void initState() {
    super.initState();
    for (final item in widget.booking.services) {
      final rating =
          item.existingReview?.rating ?? item.service.existingReview?.rating;
      if (rating != null && rating > 0) {
        _serviceRating = rating;
        break;
      }
    }
    final review = widget.booking.technicianReview;
    if (review != null && review.rating > 0) {
      _technicianRating = review.rating;
    }
  }

  BookingHistoryItem get booking => widget.booking;

  String get _serviceReviewId {
    for (final item in booking.services) {
      final candidate = item.service.id.trim();
      if (candidate.isNotEmpty) return candidate;
      final mongoCandidate = item.service.mongoId.trim();
      if (mongoCandidate.isNotEmpty) return mongoCandidate;
    }
    return '';
  }

  bool get _isCompleted => [
    'completed',
    'done',
    'paid',
  ].contains(booking.status.trim().toLowerCase());

  Future<void> _openRatingSheet(
    BuildContext context, {
    required bool serviceReview,
  }) async {
    final serviceId = _serviceReviewId;
    if (serviceReview && serviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This booking does not contain a valid service ID.".tr),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final existing = serviceReview ? _serviceRating : _technicianRating;
    final result = await showModalBottomSheet<_ReviewFormData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RatingBottomSheet(
        serviceReview: serviceReview,
        technicianName: booking.assignedTechnician.name,
        existingRating: existing,
      ),
    );
    if (result == null || !context.mounted) return;
    try {
      if (serviceReview) {
        await Get.find<ApiRepo>().submitServiceReview(
          serviceId: serviceId,
          bookingId: booking.id,
          rating: result.rating,
          review: result.review,
        );
        if (mounted) setState(() => _serviceRating = result.rating);
      } else {
        await Get.find<ApiRepo>().submitTechnicianReview(
          bookingId: booking.id,
          rating: result.rating,
          review: result.review,
        );
        if (mounted) setState(() => _technicianRating = result.rating);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (serviceReview
                      ? "Service review submitted successfully.".tr
                      : "Technician review submitted successfully.".tr)
                  .tr,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              (error.toString().replaceFirst('Exception: ', '')).tr,
            ),
            backgroundColor: const Color(0xFFA83B3B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = booking.id.length > 6
        ? booking.id.substring(booking.id.length - 6)
        : booking.id;
    return BookingPanel(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            BookingStatus(booking.status),
            Text(
              "Booking ID: @p0".trParams({"p0": (id).toString()}),
              style: const TextStyle(color: bookingMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingImage(
              booking.services.isEmpty
                  ? ''
                  : booking.services.first.service.featuredImage,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (bookingTitle(booking)).tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: bookingInk,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    (booking.services.length == 1
                            ? '@count booked service'
                            : '@count booked services')
                        .trParams({'count': '${booking.services.length}'}),
                    style: const TextStyle(color: bookingMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        BookingInfo(
          icon: Icons.calendar_today_outlined,
          text: bookingDate(booking.serviceDate),
        ),
        BookingInfo(
          icon: Icons.location_on_outlined,
          text: [
            booking.address.label,
            bookingAddress(booking.address),
          ].where((s) => s.isNotEmpty).join(' · '),
        ),
        BookingInfo(
          icon: Icons.person_outline,
          text: booking.assignedTechnician.name.isEmpty
              ? 'Technician not assigned'
              : booking.assignedTechnician.name,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1, color: bookingBorder),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              (bookingMoney(booking.totalAmount)).tr,
              style: const TextStyle(
                fontSize: 22,
                color: bookingInk,
                fontWeight: FontWeight.w800,
              ),
            ),
            BookingStatus(booking.paymentStatus),
          ],
        ),
        if (_isCompleted) ...[
          const SizedBox(height: 14),
          _InlineRatingRow(
            serviceRating: _serviceRating,
            technicianRating: _technicianRating,
            onRateService: () => _openRatingSheet(context, serviceReview: true),
            onRateTechnician: () =>
                _openRatingSheet(context, serviceReview: false),
          ),
        ],
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => BookingDetailsScreen(booking: booking),
              ),
            ),
            child: Text(
              "View details".tr,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewFormData {
  final int rating;
  final String review;

  const _ReviewFormData({required this.rating, required this.review});
}

class _InlineRatingRow extends StatelessWidget {
  final int? serviceRating;
  final int? technicianRating;
  final VoidCallback onRateService;
  final VoidCallback onRateTechnician;

  const _InlineRatingRow({
    required this.serviceRating,
    required this.technicianRating,
    required this.onRateService,
    required this.onRateTechnician,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: bookingBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _RatingCell(
                label: "Service Rating".tr,
                rating: serviceRating,
                onTap: onRateService,
              ),
            ),
            const VerticalDivider(width: 1, color: bookingBorder),
            Expanded(
              child: _RatingCell(
                label: "Technician Rating".tr,
                rating: technicianRating,
                onTap: onRateTechnician,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingCell extends StatelessWidget {
  final String label;
  final int? rating;
  final VoidCallback onTap;

  const _RatingCell({
    required this.label,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (label).tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: bookingMuted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (i) {
                final filled = rating != null && i < rating!;

                return Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 20,
                      color: filled ? Colors.amber : const Color(0xFFCCCCCC),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBottomSheet extends StatefulWidget {
  final bool serviceReview;
  final String technicianName;
  final int? existingRating;

  const _RatingBottomSheet({
    required this.serviceReview,
    required this.technicianName,
    required this.existingRating,
  });

  @override
  State<_RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<_RatingBottomSheet> {
  late int _rating;
  final _reviewController = TextEditingController();
  bool _submitting = false; // ignore: prefer_final_fields

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRating ?? 0;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingRating != null;
    final title = widget.serviceReview
        ? (isEdit ? 'Edit Service Rating' : 'Rate our service')
        : (isEdit ? 'Edit Technician Rating' : 'Rate technician');
    final subtitle = widget.serviceReview
        ? 'How was the service?'
        : widget.technicianName.isEmpty
        ? 'How was your technician?'
        : 'How was ${widget.technicianName}?';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: bookingBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              (title).tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: bookingInk,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              (subtitle).tr,
              style: const TextStyle(color: bookingMuted, fontSize: 13),
            ),
            if (isEdit) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 13,
                    color: bookingMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (widget.existingRating == 1
                            ? 'Previous rating: @count star'
                            : 'Previous rating: @count stars')
                        .trParams({'count': '${widget.existingRating}'}),
                    style: const TextStyle(color: bookingMuted, fontSize: 12),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final value = i + 1;
                  return GestureDetector(
                    onTap: _submitting
                        ? null
                        : () => setState(() => _rating = value),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        value <= _rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 42,
                        color: value <= _rating
                            ? Colors.amber
                            : const Color(0xFFCCCCCC),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                (_rating == 0
                        ? "Tap to rate".tr
                        : [
                            '',
                            "Poor".tr,
                            "Fair".tr,
                            "Good".tr,
                            "Very Good".tr,
                            "Excellent".tr,
                          ][_rating])
                    .tr,
                style: TextStyle(
                  color: _rating == 0 ? bookingMuted : Colors.amber.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reviewController,
              enabled: !_submitting,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Share your experience (optional)".tr,
                hintStyle: const TextStyle(color: bookingMuted, fontSize: 13),
                filled: true,
                fillColor: bookingBackground,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: bookingBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: bookingBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: bookingInk),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: (_submitting || _rating == 0)
                    ? null
                    : () {
                        final review = _reviewController.text.trim();
                        Navigator.of(context).pop(
                          _ReviewFormData(
                            rating: _rating,
                            review: review.isEmpty
                                ? 'No additional comments'
                                : review,
                          ),
                        );
                      },
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        (isEdit ? "Update Rating".tr : "Submit Rating".tr).tr,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  final bool loading;
  final bool filtered;
  final String error;
  final VoidCallback retry;
  final VoidCallback clear;

  const _EmptyBookings({
    required this.loading,
    required this.filtered,
    required this.error,
    required this.retry,
    required this.clear,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            error.isNotEmpty
                ? Icons.cloud_off_outlined
                : Icons.receipt_long_outlined,
            size: 42,
            color: bookingMuted,
          ),
          const SizedBox(height: 16),
          Text(
            (loading
                    ? "Loading your bookings…".tr
                    : error.isNotEmpty
                    ? "Unable to load bookings".tr
                    : filtered
                    ? "No matching bookings".tr
                    : "No bookings yet".tr)
                .tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: bookingInk,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            (error.isNotEmpty
                    ? error
                    : filtered
                    ? "Try another search or view all bookings.".tr
                    : "Your service bookings will appear here.".tr)
                .tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: bookingMuted, height: 1.5),
          ),
          if (!loading && (error.isNotEmpty || filtered))
            TextButton(
              onPressed: error.isNotEmpty ? retry : clear,
              child: Text(
                (error.isNotEmpty ? "Try again".tr : "Clear filters".tr).tr,
              ),
            ),
        ],
      ),
    ),
  );
}
