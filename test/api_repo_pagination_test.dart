import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/services/api_repo.dart';

class _RecordedRequest {
  final String path;
  final Map<String, dynamic>? query;

  const _RecordedRequest(this.path, this.query);
}

class _RecordingDioClient extends DioClient {
  final requests = <_RecordedRequest>[];

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    requests.add(_RecordedRequest(path, queryParameters));
    final data = switch (path) {
      '/api/notifications' => {
        'success': true,
        'data': {'notifications': <dynamic>[], 'unreadCount': 0},
      },
      '/api/bookings/my-bookings' => {
        'success': true,
        'data': {'bookings': <dynamic>[]},
      },
      _ when path.contains('/subcategories/') => {
        'success': true,
        'data': {'subcategories': <dynamic>[]},
      },
      _ when path.contains('/services/subcategories/') => {
        'success': true,
        'data': {'services': <dynamic>[]},
      },
      _ when path.startsWith('/api/services?') => {
        'success': true,
        'data': {'services': <dynamic>[]},
      },
      '/api/services/featured' => {
        'success': true,
        'data': {'services': <dynamic>[]},
      },
      _ => <String, dynamic>{'success': true, 'data': <String, dynamic>{}},
    };
    return Response(
      requestOptions: RequestOptions(path: path),
      data: data,
    );
  }
}

void main() {
  test(
    'booking requests include active status and search on later pages',
    () async {
      final client = _RecordingDioClient();
      await ApiRepo(
        client,
      ).getMyBookings(page: 3, status: 'Confirmed', search: ' repair ');
      expect(client.requests.single.query, {
        'page': 3,
        'limit': 10,
        'status': 'Confirmed',
        'search': 'repair',
      });
    },
  );

  test(
    'all app-owned list endpoints send page and limit query parameters',
    () async {
      final client = _RecordingDioClient();
      final repo = ApiRepo(client);

      await repo.getSubcategories('category', page: 2, limit: 10);
      await repo.getServicesBySubcategory('subcategory', page: 2, limit: 10);
      await repo.getMyBookings(page: 2, limit: 10);
      await repo.getNotifications(page: 2, limit: 10);
      await repo.searchServices('repair', page: 2, limit: 10);
      await repo.getFeaturedServices(page: 2, limit: 10);

      expect(client.requests, hasLength(6));
      for (final request in client.requests) {
        expect(request.query, {
          'page': 2,
          'limit': 10,
          if (request.path == '/api/bookings/my-bookings') 'status': 'all',
        });
      }
    },
  );
}
