import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/services/api_repo.dart';
import 'package:squadonsite/core/services/apple_auth_flow.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';
import 'package:squadonsite/model/auth_model.dart';
import 'package:squadonsite/model/apple_auth_model.dart';

class Client implements DioClient {
  final calls = <({String path, dynamic data})>[];
  dynamic appleResponse = {
    'success': true,
    'accessToken': 'app-access',
    'refreshToken': 'app-refresh',
  };
  dynamic challengeResponse = {
    'success': true,
    'nonce': 'exact nonce',
    'challengeToken': 'challenge',
  };
  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    calls.add((path: path, data: data));
    return Response(
      requestOptions: RequestOptions(path: path),
      data: path == ApiEndpoints.appleChallenge
          ? challengeResponse
          : appleResponse,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Social extends SocialAuthService {
  String? nonce;
  bool cancel = false;
  @override
  Future<bool> get isAppleSignInAvailable async => true;
  @override
  Future<SocialAuthResult> signInWithApple({required String nonce}) async {
    this.nonce = nonce;
    return cancel
        ? SocialAuthResult.cancelled()
        : SocialAuthResult.success(
            const SocialAuthUser(
              provider: SocialProvider.apple,
              uid: 'untrusted-id',
              email: 'untrusted@example.com',
              displayName: 'Apple Name',
              idToken: 'identity',
              authorizationCode: 'apple-code',
            ),
          );
  }
}

void main() {
  tearDown(Get.reset);
  test(
    'challenge preserves exact nonce; login sends only verified credentials and FCM',
    () async {
      final client = Client();
      final repo = ApiRepo(client, getFcmToken: () async => 'device-token');
      final challenge = await repo.appleChallenge();
      expect(challenge.nonce, 'exact nonce');
      expect(client.calls.single.data, isEmpty);
      final result = await repo.appleLogin(
        identityToken: 'identity',
        authorizationCode: 'apple-code',
        challengeToken: challenge.token,
      );
      expect(result.session?.accessToken, 'app-access');
      expect(result.registration, isNull);
      expect(client.calls.last.path, '/api/auth/apple');
      expect(client.calls.last.data, {
        'identityToken': 'identity',
        'authorizationCode': 'apple-code',
        'challengeToken': 'challenge',
        'fcmToken': 'device-token',
      });
    },
  );
  test(
    'new identity uses backend verified relay email and in-memory ticket',
    () async {
      final client = Client()
        ..appleResponse = {
          'success': true,
          'requiresRegistration': true,
          'appleRegistrationToken': 'ticket',
          'data': {'email': 'relay@privaterelay.appleid.com'},
        };
      final social = Social();
      Get.put<SocialAuthService>(social);
      Get.put(ApiRepo(client, getFcmToken: () async => null));
      AppleRegistration? registration;
      await AppleAuthFlow.run(onSignup: (value) => registration = value);
      expect(social.nonce, 'exact nonce');
      expect(registration?.email, 'relay@privaterelay.appleid.com');
      expect(registration?.token, 'ticket');
      expect(registration?.name, 'Apple Name');
      expect(client.calls.last.data, {
        'identityToken': 'identity',
        'authorizationCode': 'apple-code',
        'challengeToken': 'challenge',
      });
    },
  );
  test('cancellation never exchanges credentials with the backend', () async {
    final client = Client();
    Get.put<SocialAuthService>(Social()..cancel = true);
    Get.put(ApiRepo(client, getFcmToken: () async => null));
    await AppleAuthFlow.run();
    expect(client.calls.map((call) => call.path), [
      ApiEndpoints.appleChallenge,
    ]);
  });
  for (final invalid in [
    {'success': true},
    {'success': true, 'accessToken': 'app-access'},
    {
      'success': true,
      'requiresRegistration': true,
      'data': {'email': 'x@y.com'},
    },
    {'success': false, 'accessToken': 'x', 'refreshToken': 'y'},
  ]) {
    test('rejects incomplete or unsuccessful exchange $invalid', () async {
      final client = Client()..appleResponse = invalid;
      final repo = ApiRepo(client, getFcmToken: () async => null);
      await expectLater(
        repo.appleLogin(
          identityToken: 'identity',
          authorizationCode: 'apple-code',
          challengeToken: 'challenge',
        ),
        throwsFormatException,
      );
    });
  }
  test('rejects empty identity locally', () async {
    final client = Client();
    await expectLater(
      ApiRepo(client).appleLogin(
        identityToken: '',
        authorizationCode: 'apple-code',
        challengeToken: 'challenge',
      ),
      throwsArgumentError,
    );
    expect(client.calls, isEmpty);
  });
  test('signup carries ticket, ordinary signup does not', () {
    expect(
      const RegisterRequest(
        name: 'Name',
        email: 'relay@privaterelay.appleid.com',
        phone: '+919876543210',
        password: 'password',
        appleRegistrationToken: 'ticket',
      ).toJson()['appleRegistrationToken'],
      'ticket',
    );
    expect(
      const RegisterRequest(
        name: 'Name',
        email: 'x@y.com',
        phone: '+919876543210',
        password: 'password',
      ).toJson(),
      isNot(contains('appleRegistrationToken')),
    );
    expect(
      AppleRegistration(
        email: 'x@y.com',
        token: 'ticket',
        expiresAt: DateTime(2000),
      ).isExpired,
      isTrue,
    );
  });
}
