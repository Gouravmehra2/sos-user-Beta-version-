import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/dio_exception_handler/dio_exception_handler.dart';
import 'package:squadonsite/core/services/apple_auth_flow.dart';

void main() {
  String message(dynamic body) {
    final request = RequestOptions(path: '/api/auth/apple');
    return DioExceptionHandler.handle(
      DioException(
        requestOptions: request,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: request,
          statusCode: 400,
          data: body,
        ),
      ),
    ).message;
  }

  test(
    'preserves backend rejection detail instead of a generic 400 message',
    () {
      expect(
        message({
          'message': 'Apple rejected the authorization code: invalid_grant',
        }),
        'Apple rejected the authorization code: invalid_grant',
      );
      expect(
        message({
          'error': {
            'message': 'authorizationCode is required',
            'identityToken': 'secret',
          },
        }),
        'authorizationCode is required',
      );
      expect(message({'error': 'Challenge expired'}), 'Challenge expired');
    },
  );
  test('includes field validation details even when a summary is present', () {
    expect(
      message({
        'message': 'Validation failed',
        'errors': [
          {'field': 'authorizationCode', 'message': 'Required'},
          {'field': 'challengeToken', 'message': 'Required'},
        ],
      }),
      'Validation failed\nauthorizationCode: Required\nchallengeToken: Required',
    );
  });
  test('empty responses explain that the backend supplied no reason', () {
    expect(
      message({'message': ''}),
      contains('without an error message (HTTP 400)'),
    );
  });
  test('Apple diagnostics remove submitted credentials and JWT values', () {
    expect(
      AppleAuthFlow.errorMessage(
        'Apple rejected code secret-code; nonce secret-nonce; eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxIn0.signature',
        ['secret-code', 'secret-nonce'],
      ),
      'Apple rejected code [redacted]; nonce [redacted]; [redacted]',
    );
  });
}
