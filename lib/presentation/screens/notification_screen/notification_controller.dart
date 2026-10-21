import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'model/notification_model.dart';

class NotificationController extends GetxController {
  static const int pageSize = 10;

  final notifications = <AppNotification>[].obs;
  final scrollController = ScrollController();
  final unreadCount = 0.obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final isMarkingAllRead = false.obs;
  final updatingNotificationIds = <String>{}.obs;
  final errorMessage = ''.obs;
  int _page = 1;
  bool _requestInProgress = false;
  int _generation = 0;
  bool _refreshPending = false;

  void clearAccountState() {
    _generation++;
    _refreshPending = false;
    notifications.clear();
    unreadCount.value = 0;
    errorMessage.value = '';
    _page = 1;
    hasMore.value = true;
  }

  bool get hasNotifications => notifications.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchNotifications();
  }

  void _onScroll() {
    if (!scrollController.hasClients ||
        scrollController.position.extentAfter > 300) {
      return;
    }
    loadMoreNotifications();
  }

  Future<void> fetchNotifications({
    bool showLoading = true,
    bool reset = true,
  }) async {
    if (_requestInProgress) {
      if (reset) _refreshPending = true;
      return;
    }
    final generation = _generation;
    if (!reset && !hasMore.value) return;
    _requestInProgress = true;
    if (reset) {
      _page = 1;
      hasMore.value = true;
      if (showLoading) isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    errorMessage.value = '';
    try {
      final requestedPage = reset ? 1 : _page + 1;
      final response = await Get.find<ApiRepo>().getNotifications(
        page: requestedPage,
        limit: pageSize,
      );
      if (generation != _generation || isClosed) return;
      if (!response.success) {
        throw Exception('Unable to load notifications.');
      }
      if (reset) {
        notifications.assignAll(response.data.notifications);
        hasMore.value =
            response.data.hasMore && response.data.notifications.isNotEmpty;
      } else {
        final existingIds = notifications.map((item) => item.id).toSet();
        final newItems = response.data.notifications
            .where((item) => item.id.isEmpty || !existingIds.contains(item.id))
            .toList();
        notifications.addAll(newItems);
        hasMore.value = response.data.hasMore && newItems.isNotEmpty;
      }
      _page = requestedPage;
      unreadCount.value = response.data.unreadCount;
    } catch (_) {
      if (generation == _generation && !isClosed) {
        errorMessage.value =
            "Unable to load notifications. Please try again.".tr;
      }
    } finally {
      _requestInProgress = false;
      isLoading.value = false;
      isLoadingMore.value = false;
      if (_refreshPending && !isClosed) {
        _refreshPending = false;
        fetchNotifications(showLoading: false);
      }
    }
  }

  Future<void> loadMoreNotifications() =>
      fetchNotifications(showLoading: false, reset: false);

  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0 || isMarkingAllRead.value) return;

    isMarkingAllRead.value = true;
    try {
      await Get.find<ApiRepo>().markAllNotificationsAsRead();
      await _refreshLoadedPages();
    } catch (_) {
      errorMessage.value =
          "Unable to update notifications. Please try again.".tr;
    } finally {
      isMarkingAllRead.value = false;
    }
  }

  Future<void> markAsRead(AppNotification notification) async {
    if (notification.isRead ||
        notification.id.isEmpty ||
        updatingNotificationIds.contains(notification.id)) {
      return;
    }

    updatingNotificationIds.add(notification.id);
    try {
      await Get.find<ApiRepo>().markNotificationAsRead(notification.id);
      await _refreshLoadedPages();
    } catch (_) {
      errorMessage.value =
          "Unable to update notification. Please try again.".tr;
    } finally {
      updatingNotificationIds.remove(notification.id);
    }
  }

  Future<void> _refreshLoadedPages() async {
    final loadedPage = _page;
    await fetchNotifications(showLoading: false);
    while (_page < loadedPage && hasMore.value && errorMessage.value.isEmpty) {
      await loadMoreNotifications();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
