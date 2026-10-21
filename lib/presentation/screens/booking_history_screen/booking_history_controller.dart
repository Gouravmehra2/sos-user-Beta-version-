import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'model/booking_history_model.dart';

class BookingHistoryController extends GetxController {
  static const int pageSize = 10;

  final bookings = <BookingHistoryItem>[].obs;
  final scrollController = ScrollController();
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final errorMessage = ''.obs;
  int _page = 1;
  int _requestVersion = 0;
  Timer? _searchDebounce;
  String status = 'all';
  String search = '';

  void applyFilter(String value, String query, {bool debounce = false}) {
    _searchDebounce?.cancel();
    status = value;
    search = query.trim();
    ++_requestVersion;
    bookings.clear();
    isLoading.value = true;
    isLoadingMore.value = false;
    errorMessage.value = '';
    hasMore.value = true;
    _page = 1;
    if (scrollController.hasClients) scrollController.jumpTo(0);
    if (debounce) {
      _searchDebounce = Timer(const Duration(milliseconds: 350), fetchBookings);
    } else {
      fetchBookings();
    }
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchBookings();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        scrollController.position.extentAfter > 300) {
      return;
    }
    loadMoreBookings();
  }

  Future<void> fetchBookings() {
    _searchDebounce?.cancel();
    return _fetchBookings(reset: true);
  }

  Future<void> _fetchBookings({required bool reset}) async {
    if (reset) {
      ++_requestVersion;
      isLoadingMore.value = false;
      _page = 1;
      hasMore.value = true;
      isLoading.value = true;
    } else {
      if (isLoading.value || isLoadingMore.value || !hasMore.value) return;
      isLoadingMore.value = true;
    }
    final version = _requestVersion;
    errorMessage.value = '';
    try {
      final requestedPage = reset ? 1 : _page + 1;
      final response = await Get.find<ApiRepo>().getMyBookings(
        page: requestedPage,
        limit: pageSize,
        status: status,
        search: search,
      );
      if (version != _requestVersion) return;
      if (response.success) {
        if (reset) {
          bookings.assignAll(response.bookings);
          hasMore.value = response.hasMore && response.bookings.isNotEmpty;
        } else {
          final existingIds = bookings.map((booking) => booking.id).toSet();
          final newBookings = response.bookings
              .where(
                (booking) =>
                    booking.id.isEmpty || !existingIds.contains(booking.id),
              )
              .toList();
          bookings.addAll(newBookings);
          hasMore.value = response.hasMore && newBookings.isNotEmpty;
        }
        _page = requestedPage;
      } else {
        errorMessage.value = 'Unable to load your bookings.';
      }
    } catch (_) {
      if (version != _requestVersion) return;
      errorMessage.value = 'Unable to load your bookings. Please try again.';
    } finally {
      if (version == _requestVersion) {
        isLoading.value = false;
        isLoadingMore.value = false;
      }
    }
  }

  Future<void> loadMoreBookings() => _fetchBookings(reset: false);

  @override
  void onClose() {
    _searchDebounce?.cancel();
    ++_requestVersion;
    scrollController.dispose();
    super.onClose();
  }
}
