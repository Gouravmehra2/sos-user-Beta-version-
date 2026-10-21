import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/pagination/pagination_info.dart';

void main() {
  group('PaginationInfo.fromResponse', () {
    test('uses explicit hasNextPage metadata when present', () {
      final info = PaginationInfo.fromResponse(
        response: const {'data': {}, 'pagination': {'hasNextPage': true}},
        data: const {},
        page: 1,
        limit: 10,
        itemCount: 10,
      );

      expect(info.hasMore, isTrue);
    });

    test('uses totalPages metadata when present', () {
      final info = PaginationInfo.fromResponse(
        response: const {},
        data: const {'pagination': {'currentPage': 2, 'totalPages': 3}},
        page: 2,
        limit: 10,
        itemCount: 10,
      );

      expect(info.hasMore, isTrue);
    });

    test('falls back to whether the current page is full', () {
      final fullPage = PaginationInfo.fromResponse(
        response: const {},
        data: const {},
        page: 1,
        limit: 10,
        itemCount: 10,
      );
      final lastPage = PaginationInfo.fromResponse(
        response: const {},
        data: const {},
        page: 2,
        limit: 10,
        itemCount: 4,
      );

      expect(fullPage.hasMore, isTrue);
      expect(lastPage.hasMore, isFalse);
    });
  });
}
