import 'dart:convert';
import 'dart:async';
import 'firebase_notification_service.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:squadonsite/model/auth_model.dart';

class AuthSession {
  static const String responseKey = 'auth_response';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String accessToken = '';
  String refreshToken = '';
  AuthUser? user;

  bool get hasToken => accessToken.trim().isNotEmpty;

  Future<void> restoreFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Migrate existing installations before removing plaintext credentials.
    final saved =
        await _storage.read(key: responseKey) ?? prefs.getString(responseKey);
    AuthResponse? response;
    if (saved != null && saved.isNotEmpty) {
      try {
        final decoded = jsonDecode(saved);
        if (decoded is Map<String, dynamic>) {
          response = AuthResponse.fromJson(decoded);
        }
      } catch (_) {
        // Invalid profile data must not crash startup.
      }
    }
    accessToken =
        await _storage.read(key: 'auth_token') ??
        prefs.getString('auth_token') ??
        response?.accessToken ??
        '';
    refreshToken =
        await _storage.read(key: 'refresh_token') ??
        prefs.getString('refresh_token') ??
        response?.refreshToken ??
        '';
    user = response?.user;
    await _persist();
    unawaited(FirebaseNotificationService.onSessionReady());
  }

  Future<void> clearSession() async {
    FirebaseNotificationService.clearAccountState();
    try {
      for (final key in ['auth_token', 'refresh_token', responseKey]) {
        await _storage.delete(key: key);
      }
      await _removeLegacyCredentials();
    } finally {
      accessToken = '';
      refreshToken = '';
      user = null;
    }
  }

  Future<void> clearLocalData() async {
    try {
      await clearSession();
    } finally {
      final prefs = await SharedPreferences.getInstance();
      for (final key in prefs.getKeys()) {
        if (!key.startsWith('plan_checkout_')) {
          await prefs.remove(key);
        }
      }
    }
  }

  Future<void> update(AuthResponse response) async {
    final previousAccess = accessToken;
    final previousRefresh = refreshToken;
    final previousUser = user;
    if (previousUser != null &&
        response.user != null &&
        previousUser.id != response.user!.id) {
      FirebaseNotificationService.clearAccountState();
    }
    accessToken = response.accessToken.trim().isNotEmpty
        ? response.accessToken
        : accessToken;
    refreshToken = response.refreshToken.trim().isNotEmpty
        ? response.refreshToken
        : refreshToken;
    user = response.user ?? user;
    try {
      await _persist();
      unawaited(FirebaseNotificationService.onSessionReady());
    } catch (_) {
      accessToken = previousAccess;
      refreshToken = previousRefresh;
      user = previousUser;
      // Remove any partially written session before allowing another attempt.
      await clearSession();
      rethrow;
    }
  }

  Future<void> _persist() async {
    await _storage.write(key: 'auth_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(
      key: responseKey,
      value: jsonEncode({
        'success': true,
        if (user != null) 'data': {'user': user!.toJson()},
      }),
    );
    await _removeLegacyCredentials();
  }

  Future<void> _removeLegacyCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove(responseKey);
  }
}
