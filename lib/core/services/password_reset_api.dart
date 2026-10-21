import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:squadonsite/core/end_points/api_endpoints.dart';

class ResetApiException implements Exception {
  final int statusCode;
  final String message;

  const ResetApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}

class PasswordResetApi {
  PasswordResetApi(String baseUrl, {http.Client? client})
    : baseUrl = _normalizeBaseUrl(baseUrl),
      client = client ?? http.Client();

  final String baseUrl;
  final http.Client client;

  static String _normalizeBaseUrl(String baseUrl) {
    final normalized = baseUrl.replaceFirst(RegExp(r'/+$'), '');
    if (!normalized.endsWith('/api')) {
      throw ArgumentError.value(baseUrl, 'baseUrl', 'must end with /api');
    }
    return normalized;
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, String> body,
  ) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('Password reset API POST $uri');
    final response = await client
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ResetApiException(
        response.statusCode,
        'Unexpected server response',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw ResetApiException(
        response.statusCode,
        'Unexpected server response',
      );
    }
    if (response.statusCode != 200 || decoded['success'] != true) {
      final message = decoded['message'];
      throw ResetApiException(
        response.statusCode,
        message is String && message.trim().isNotEmpty
            ? message
            : 'Request failed. Please try again.',
      );
    }
    return decoded;
  }

  Future<Map<String, dynamic>> forgotPassword(String identifier) =>
      _post(ApiEndpoints.forgotPassword, {'identifier': identifier.trim()});

  Future<Map<String, dynamic>> resendOtp(String identifier) => _post(
    ApiEndpoints.resendPasswordResetOtp,
    {'identifier': identifier.trim()},
  );

  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String otp,
    required String newPassword,
  }) => _post(ApiEndpoints.resetPassword, {
    'phone': phone,
    'otp': otp.trim(),
    'newPassword': newPassword,
  });

  void close() => client.close();
}
