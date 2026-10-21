import 'package:dio/dio.dart';
import 'api_exception.dart';

class DioExceptionHandler {
  static ApiException handle(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(message: 'Connection timeout. Please try again.');
      case DioExceptionType.sendTimeout:
        return const ApiException(message: 'Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        return const ApiException(message: 'Server response timeout. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException(message: 'No internet connection.');
      case DioExceptionType.badCertificate:
        return const ApiException(message: 'Invalid server certificate.');
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      case DioExceptionType.badResponse:
        return _handleBadResponse(exception);
      case DioExceptionType.transformTimeout:
        return const ApiException(message: 'Data transformation timeout.');
      case DioExceptionType.unknown:
        return ApiException(message: exception.message ?? 'Something went wrong.');
    }
  }

  static ApiException _handleBadResponse(DioException exception) {
    final response = exception.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    final message = data is Map
        ? (data['message']?.toString() ?? data['error']?.toString())
        : null;

    final fallback = switch (statusCode) {
      401 => 'Unauthorized. Please login again.',
      403 => 'You do not have permission.',
      404 => 'Requested resource not found.',
      500 => 'Internal server error.',
      _ => 'Something went wrong.',
    };
    return ApiException(message: message ?? fallback, statusCode: statusCode);
  }
}