import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:squadonsite/core/dio_exception_handler/dio_exception_handler.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';

class DioClient {
  late final Dio dio;
  static Future<void>? _unauthorizedCleanup;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await const FlutterSecureStorage().read(
            key: 'auth_token',
          );
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) async {
          if (response.statusCode == 401) {
            await _handleUnauthorizedResponse();
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _handleUnauthorizedResponse();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode &&
        const bool.fromEnvironment('HTTP_LOGGING', defaultValue: true)) {
      dio.interceptors.add(
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
          logPrint: (object) => debugPrint(object.toString(), wrapWidth: 120),
        ),
      );
    }
  }

  static Future<void> _handleUnauthorizedResponse() async {
    try {
      await _clearUnauthorizedSessionOnce();
    } catch (cleanupError, stackTrace) {
      debugPrint(
        'Failed to clear the local session after an API 401: '
        '$cleanupError\n$stackTrace',
      );
    }
  }

  static Future<void> _clearUnauthorizedSessionOnce() async {
    final currentCleanup = _unauthorizedCleanup;
    if (currentCleanup != null) {
      await currentCleanup;
      return;
    }

    final cleanup = _clearUnauthorizedSession();
    _unauthorizedCleanup = cleanup;
    try {
      await cleanup;
    } finally {
      _unauthorizedCleanup = null;
    }
  }

  static Future<void> _clearUnauthorizedSession() async {
    final session = Get.isRegistered<AuthSession>()
        ? Get.find<AuthSession>()
        : null;
    final shouldNavigateToLogin = session?.hasToken ?? false;
    try {
      await session?.clearLocalData();
    } finally {
      if (Get.isRegistered<SocialAuthService>()) {
        await Get.find<SocialAuthService>().signOutGoogle();
      }
      if (shouldNavigateToLogin) {
        Get.offAllNamed(AppRoutes.onboardingScreen);
      }
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.handle(error);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (error) {
      throw DioExceptionHandler.handle(error);
    }
  }

  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      return await dio.put(path, data: data, options: options);
    } on DioException catch (error) {
      throw DioExceptionHandler.handle(error);
    }
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    try {
      return await dio.patch(path, data: data, options: options);
    } on DioException catch (error) {
      throw DioExceptionHandler.handle(error);
    }
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      return await dio.delete(path, data: data, options: options);
    } on DioException catch (error) {
      throw DioExceptionHandler.handle(error);
    }
  }
}
