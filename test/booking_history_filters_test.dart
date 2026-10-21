import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/booking_history_controller.dart';
import 'package:squadonsite/presentation/screens/booking_history_screen/model/booking_history_model.dart';
import 'package:squadonsite/presentation/screens/dashboard/dashboard_controller.dart';

class _Repo implements ApiRepo {
  final requests =
      <
        ({
          String status,
          String search,
          int page,
          Completer<BookingHistoryResponse> result,
        })
      >[];
  @override
  Future<BookingHistoryResponse> getMyBookings({
    int page = 1,
    int limit = 10,
    String status = 'all',
    String search = '',
  }) {
    final result = Completer<BookingHistoryResponse>();
    requests.add((status: status, search: search, page: page, result: result));
    return result.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

BookingHistoryResponse response(String id) => BookingHistoryResponse.fromJson({
  'success': true,
  'data': {
    'bookings': List.generate(10, (i) => {'_id': '$id-$i'}),
  },
});
void main() {
  tearDown(Get.reset);
  test('opening cached Bookings refreshes page one, even if selected', () async {
    final repo = _Repo();
    Get.put<ApiRepo>(repo);
    final history = Get.put(BookingHistoryController());
    final dashboard = DashboardController();
    repo.requests.single.result.complete(response('old'));
    await Future<void>.delayed(Duration.zero);
    final nextPage = history.loadMoreBookings();
    repo.requests.last.result.complete(response('page-two'));
    await nextPage;
    expect(repo.requests.last.page, 2);

    dashboard.changeIndex(index: DashboardController.bookingsIndex);
    expect(repo.requests, hasLength(3));
    expect(repo.requests.last.page, 1);
    repo.requests.last.result.complete(response('new-booking'));
    await Future<void>.delayed(Duration.zero);
    expect(history.bookings.first.id, 'new-booking-0');
    expect(history.bookings, hasLength(10));

    dashboard.changeIndex(index: DashboardController.bookingsIndex);
    expect(repo.requests, hasLength(4));
    repo.requests.last.result.complete(response('updated'));
    await Future<void>.delayed(Duration.zero);
    expect(history.bookings.first.id, 'updated-0');
  });

  test('opening Bookings initially leaves the first fetch to onInit', () async {
    final repo = _Repo();
    Get.put<ApiRepo>(repo);
    Get.lazyPut(() => BookingHistoryController());
    DashboardController().changeIndex(index: DashboardController.bookingsIndex);
    expect(repo.requests, isEmpty);
    Get.find<BookingHistoryController>();
    expect(repo.requests, hasLength(1));
    repo.requests.single.result.complete(response('initial'));
    await Future<void>.delayed(Duration.zero);
  });

  test(
    'tab changes ignore stale responses and paginate the active query',
    () async {
      final repo = _Repo();
      Get.put<ApiRepo>(repo);
      final controller = BookingHistoryController();
      final initial = controller.fetchBookings();
      controller.applyFilter('Pending', 'repair');
      repo.requests[1].result.complete(response('pending'));
      await Future<void>.delayed(Duration.zero);
      repo.requests[0].result.complete(response('old'));
      await initial;
      expect(controller.bookings.first.id, 'pending-0');
      final next = controller.loadMoreBookings();
      expect(repo.requests.last.status, 'Pending');
      expect(repo.requests.last.search, 'repair');
      expect(repo.requests.last.page, 2);
      controller.applyFilter('Completed', '');
      repo.requests[2].result.complete(response('stale-page'));
      await next;
      expect(controller.bookings, isEmpty);
      expect(controller.isLoading.value, isTrue);
      expect(repo.requests.last.page, 1);
      repo.requests.last.result.complete(response('completed'));
      await Future<void>.delayed(Duration.zero);
      expect(controller.bookings.first.id, 'completed-0');
      controller.onClose();
    },
  );
}
