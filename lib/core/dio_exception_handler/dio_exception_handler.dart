import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'api_exception.dart';

class DioExceptionHandler {
  static ApiException handle(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: "Connection timeout. Please try again.".tr,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(message: "Request timeout. Please try again.".tr);
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Server response timeout. Please try again.".tr,
        );
      case DioExceptionType.connectionError:
        return ApiException(message: "No internet connection.".tr);
      case DioExceptionType.badCertificate:
        return ApiException(message: "Invalid server certificate.".tr);
      case DioExceptionType.cancel:
        return ApiException(message: "Request was cancelled.".tr);
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);
      case DioExceptionType.transformTimeout:
        return ApiException(message: "Data transformation timeout.".tr);
      case DioExceptionType.unknown:
        return ApiException(
          message: exception.message ?? "Something went wrong.".tr,
        );
    }
  }

  static ApiException _handleBadResponse(DioException exception) {
    final response = exception.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    String? text(dynamic value) =>
        value is String && value.trim().isNotEmpty ? value : null;
    final nestedError = data is Map ? data['error'] : null;
    final nestedData = data is Map ? data['data'] : null;
    var message = data is Map
        ? text(data['message']) ??
              text(nestedError) ??
              (nestedError is Map ? text(nestedError['message']) : null) ??
              (nestedData is Map ? text(nestedData['message']) : null)
        : text(data);
    if (data is Map && data['errors'] is List) {
      final validationMessages = (data['errors'] as List)
          .whereType<Map>()
          .map((error) {
            final detail = text(error['message']);
            final field = text(error['field']);
            return detail == null
                ? null
                : field == null
                ? detail
                : '$field: $detail';
          })
          .whereType<String>()
          .where((message) => message.trim().isNotEmpty)
          .toSet();
      if (validationMessages.isNotEmpty) {
        message = {?message, ...validationMessages}.join('\n');
      }
    }

    final fallback = switch (statusCode) {
      401 => 'Unauthorized. Please login again.',
      400 =>
        'The server rejected the request without an error message (HTTP 400).',
      403 => 'You do not have permission.',
      404 => 'Requested resource not found.',
      500 => 'Internal server error.',
      _ => 'Something went wrong.',
    };
    return ApiException(message: message ?? fallback, statusCode: statusCode);
  }
}
