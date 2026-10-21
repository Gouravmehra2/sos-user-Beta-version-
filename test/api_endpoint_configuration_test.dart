import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';

void main() {
  test(
    'release endpoint override applies to login, bookings, profile and Places',
    () {
      const configured = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://192.168.1.79:5001/api',
      );
      final expected = Uri.parse(configured);
      for (final path in [
        ApiEndpoints.login,
        ApiEndpoints.createBooking,
        ApiEndpoints.me,
      ]) {
        final request = RequestOptions(
          baseUrl: ApiEndpoints.baseUrl,
          path: path,
        );
        expect(request.uri.scheme, expected.scheme);
        expect(request.uri.host, expected.host);
        expect(request.uri.port, expected.port);
        expect(request.uri.path, path);
      }
      final places = Uri.parse(
        '${ApiEndpoints.apiBaseUrl}/places/autocomplete',
      );
      expect(places.host, Uri.parse(ApiEndpoints.baseUrl).host);
      expect(places.path, '/api/places/autocomplete');
    },
  );
}
