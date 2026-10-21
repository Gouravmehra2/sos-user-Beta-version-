class PaginationInfo {
  final int page;
  final int limit;
  final bool hasMore;

  const PaginationInfo({
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory PaginationInfo.fromResponse({
    required Map<String, dynamic> response,
    required Map<String, dynamic> data,
    required int page,
    required int limit,
    required int itemCount,
  }) {
    final candidates = <Map<String, dynamic>>[
      if (response['pagination'] is Map)
        Map<String, dynamic>.from(response['pagination'] as Map),
      if (response['meta'] is Map)
        Map<String, dynamic>.from(response['meta'] as Map),
      if (response['meta'] is Map &&
          (response['meta'] as Map)['pagination'] is Map)
        Map<String, dynamic>.from(
          (response['meta'] as Map)['pagination'] as Map,
        ),
      if (data['pagination'] is Map)
        Map<String, dynamic>.from(data['pagination'] as Map),
      if (data['meta'] is Map) Map<String, dynamic>.from(data['meta'] as Map),
      if (data['meta'] is Map && (data['meta'] as Map)['pagination'] is Map)
        Map<String, dynamic>.from((data['meta'] as Map)['pagination'] as Map),
      data,
      response,
    ];

    for (final candidate in candidates) {
      for (final key in const ['hasNextPage', 'hasMore', 'hasNext']) {
        final value = candidate[key];
        if (value is bool) {
          return PaginationInfo(page: page, limit: limit, hasMore: value);
        }
      }
      if (candidate.containsKey('nextPage')) {
        return PaginationInfo(
          page: page,
          limit: limit,
          hasMore: candidate['nextPage'] != null,
        );
      }

      final totalPages = _number(
        candidate['totalPages'] ?? candidate['pages'] ?? candidate['lastPage'],
      );
      if (totalPages != null) {
        final currentPage =
            _number(candidate['currentPage'] ?? candidate['page']) ?? page;
        return PaginationInfo(
          page: page,
          limit: limit,
          hasMore: currentPage < totalPages,
        );
      }

      final totalItems = _number(
        candidate['totalItems'] ?? candidate['total'] ?? candidate['count'],
      );
      if (totalItems != null) {
        return PaginationInfo(
          page: page,
          limit: limit,
          hasMore: page * limit < totalItems,
        );
      }
    }

    return PaginationInfo(
      page: page,
      limit: limit,
      hasMore: itemCount >= limit,
    );
  }

  static int? _number(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
}

class PaginatedItems<T> {
  final List<T> items;
  final bool hasMore;

  const PaginatedItems({required this.items, required this.hasMore});
}
