import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/pagination/pagination_info.dart';
import 'package:squadonsite/presentation/screens/home_screen/home_controller.dart';
import 'package:squadonsite/presentation/screens/service_screen/model/service_screen_model.dart';

class _Repo implements ApiRepo {
  final requests = <String, Completer<PaginatedItems<ServiceItem>>>{};
  @override
  Future<PaginatedItems<ServiceItem>> searchServices(
    String query, {
    int page = 1,
    int limit = 10,
  }) {
    final request = Completer<PaginatedItems<ServiceItem>>();
    requests[query] = request;
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Home extends HomeController {
  @override
  Future<void> fetchUserProfile() async {}
  @override
  Future<void> fetchFeaturedServices() async {}
}

void main() {
  testWidgets('search debounces input and ignores stale and cleared results', (
    tester,
  ) async {
    Get.testMode = true;
    final repo = Get.put<ApiRepo>(_Repo()) as _Repo;
    final controller = Get.put<HomeController>(_Home());
    addTearDown(Get.reset);
    controller.onSearchChanged('p');
    expect(controller.showSearchSuggestions.value, isTrue);
    controller.hideSearchSuggestions();
    expect(controller.showSearchSuggestions.value, isFalse);
    controller.showSearchSuggestionsAgain();
    expect(controller.showSearchSuggestions.value, isTrue);
    await tester.pump(const Duration(milliseconds: 100));
    controller.onSearchChanged('printer');
    await tester.pump(const Duration(milliseconds: 301));
    expect(repo.requests.keys, ['printer']);
    controller.onSearchChanged('computer');
    await tester.pump(const Duration(milliseconds: 301));
    repo.requests['computer']!.complete(
      PaginatedItems(
        items: [
          ServiceItem.fromJson({'name': 'Computer'}),
        ],
        hasMore: false,
      ),
    );
    await tester.pump();
    repo.requests['printer']!.complete(
      PaginatedItems(
        items: [
          ServiceItem.fromJson({'name': 'Printer'}),
        ],
        hasMore: false,
      ),
    );
    await tester.pump();
    expect(controller.searchResults.single.name, 'Computer');
    controller.onSearchChanged('repair');
    await tester.pump(const Duration(milliseconds: 301));
    controller.clearSearch();
    repo.requests['repair']!.complete(
      PaginatedItems(
        items: [
          ServiceItem.fromJson({'name': 'Repair'}),
        ],
        hasMore: false,
      ),
    );
    await tester.pump();
    expect(controller.searchResults, isEmpty);
    expect(controller.isSearchMode.value, isFalse);
    expect(controller.showSearchSuggestions.value, isFalse);
    expect(controller.isLoadingSearch.value, isFalse);
    await tester.pump(const Duration(milliseconds: 301));
  });
}
