import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/model/auth_model.dart';

class _RecordingClient implements DioClient {
  final payloads = <String, dynamic>{};

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    payloads[path] = data;
    return Response(
      requestOptions: RequestOptions(path: path),
      data: {'success': true},
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('login and both signup steps send the current FCM token', () async {
    final client = _RecordingClient();
    var token = 'first-token';
    final repo = ApiRepo(client, getFcmToken: () async => token);
    await repo.login(
      const LoginRequest(email: 'user@example.com', password: 'password'),
    );
    token = 'refreshed-token';
    await repo.startRegister(
      const RegisterRequest(
        name: 'User',
        email: 'user@example.com',
        phone: '1234567890',
        password: 'password',
      ),
    );
    await repo.verifyRegister(
      const VerifyRegisterRequest(phone: '1234567890', code: '123456'),
    );

    expect(client.payloads[ApiEndpoints.login], {
      'email': 'user@example.com',
      'password': 'password',
      'fcmToken': 'first-token',
    });
    expect(client.payloads[ApiEndpoints.startRegister], {
      'name': 'User',
      'email': 'user@example.com',
      'phone': '1234567890',
      'password': 'password',
      'fcmToken': 'refreshed-token',
    });
    expect(client.payloads[ApiEndpoints.verifyRegister], {
      'phone': '1234567890',
      'code': '123456',
      'fcmToken': 'refreshed-token',
    });
  });

  for (final unavailable in <String?>[null, '', '   ']) {
    test(
      'login continues when token is ${unavailable == null ? 'null' : 'blank'}',
      () async {
        final client = _RecordingClient();
        final repo = ApiRepo(client, getFcmToken: () async => unavailable);
        await repo.login(
          const LoginRequest(phone: '1234567890', password: 'password'),
        );
        expect(
          client.payloads[ApiEndpoints.login],
          isNot(contains('fcmToken')),
        );
        expect(client.payloads[ApiEndpoints.login]['phone'], '1234567890');
      },
    );
  }

  test('Firebase failure does not block authentication', () async {
    final client = _RecordingClient();
    final repo = ApiRepo(
      client,
      getFcmToken: () async => throw StateError('Unavailable'),
    );
    final response = await repo.login(
      const LoginRequest(email: 'user@example.com', password: 'password'),
    );
    expect(response.success, isTrue);
    expect(client.payloads[ApiEndpoints.login], isNot(contains('fcmToken')));
  });
}
