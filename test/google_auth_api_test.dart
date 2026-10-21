import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/dio_exception_handler/api_exception.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';

class _Client implements DioClient {
  Object? error;
  dynamic body = {
    'success': true,
    'accessToken': 'app-access',
    'refreshToken': 'app-refresh',
  };
  String? path;
  dynamic payload;

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    this.path = path;
    payload = data;
    if (error != null) throw error!;
    return Response(
      requestOptions: RequestOptions(path: path),
      data: body,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Google login sends Firebase identity and current FCM, returns app tokens',
    () async {
      final client = _Client();
      final repo = ApiRepo(client, getFcmToken: () async => 'push-token');
      final result = await repo.googleLogin('firebase-identity');
      expect(client.path, ApiEndpoints.googleLogin);
      expect(client.payload, {
        'firebaseIdToken': 'firebase-identity',
        'fcmToken': 'push-token',
      });
      expect(result.accessToken, 'app-access');
      expect(result.refreshToken, 'app-refresh');
    },
  );

  test('Google login continues when push is unavailable', () async {
    final client = _Client();
    final repo = ApiRepo(
      client,
      getFcmToken: () async => throw StateError('push unavailable'),
    );
    expect((await repo.googleLogin('identity')).success, isTrue);
    expect(client.payload['firebaseIdToken'], 'identity');
    expect(client.payload, isNot(contains('fcmToken')));
  });

  test(
    'Google auth rejects a blank Firebase token before making a request',
    () async {
      final client = _Client();
      final repo = ApiRepo(client);
      await expectLater(repo.googleLogin('  '), throwsArgumentError);
      await expectLater(repo.googleSignup(''), throwsArgumentError);
      expect(client.path, isNull);
    },
  );

  for (final body in [
    {'success': true},
    {'success': true, 'accessToken': 'app-access'},
    {'success': true, 'refreshToken': 'app-refresh'},
    {
      'success': false,
      'accessToken': 'app-access',
      'refreshToken': 'app-refresh',
    },
    'invalid response',
  ]) {
    test(
      'Google login rejects incomplete or unsuccessful response $body',
      () async {
        final client = _Client()..body = body;
        final repo = ApiRepo(client, getFcmToken: () async => null);
        await expectLater(
          repo.googleLogin('identity'),
          throwsA(isA<Exception>()),
        );
      },
    );
  }

  test(
    'Google signup uses backend verified identity and sends only Firebase token',
    () async {
      final client = _Client()
        ..body = {
          'success': true,
          'data': {'name': 'Verified Name', 'email': 'verified@example.com'},
        };
      final repo = ApiRepo(client, getFcmToken: () async => 'push');
      final identity = await repo.googleSignup('identity');
      expect(client.path, ApiEndpoints.googleSignup);
      expect(client.payload, {'firebaseIdToken': 'identity'});
      expect(identity, (name: 'Verified Name', email: 'verified@example.com'));
    },
  );

  test(
    'Google signup accepts verified identity fields without a success flag',
    () async {
      final client = _Client()
        ..body = {'name': 'Verified Name', 'email': 'verified@example.com'};
      final identity = await ApiRepo(client).googleSignup('identity');
      expect(identity, (name: 'Verified Name', email: 'verified@example.com'));
    },
  );

  test('Google signup rejects missing verified email', () async {
    final client = _Client()
      ..body = {
        'success': true,
        'data': {'name': 'Name'},
      };
    await expectLater(
      ApiRepo(client).googleSignup('identity'),
      throwsFormatException,
    );
  });

  for (final body in [
    {
      'success': false,
      'data': {'name': 'Name', 'email': 'verified@example.com'},
    },
    {
      'success': true,
      'data': {'name': '  ', 'email': 'verified@example.com'},
    },
  ]) {
    test(
      'Google signup rejects unsuccessful or incomplete response $body',
      () async {
        final client = _Client()..body = body;
        await expectLater(
          ApiRepo(client).googleSignup('identity'),
          throwsFormatException,
        );
      },
    );
  }

  for (final status in [400, 401, 403, 404, 409, 500]) {
    test('Google API preserves status $status for flow handling', () async {
      final client = _Client()
        ..error = ApiException(message: 'Rejected', statusCode: status);
      final repo = ApiRepo(client, getFcmToken: () async => null);
      await expectLater(
        repo.googleLogin('identity'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', status),
        ),
      );
      await expectLater(
        repo.googleSignup('identity'),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'status', status),
        ),
      );
    });
  }
}
