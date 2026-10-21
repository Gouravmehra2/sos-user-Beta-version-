import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Centralised social authentication service.
///
/// Register once in your GetX bindings / app initialisation:
/// ```dart
/// Get.put(SocialAuthService(), permanent: true);
/// ```
///
/// Then call from any controller:
/// ```dart
/// final _auth = Get.find<SocialAuthService>();
///
/// // Google
/// final result = await _auth.signInWithGoogle();
/// result.fold(
///   onSuccess: (user) { /* navigate */ },
///   onFailure: (msg)  { /* show snackbar */ },
/// );
///
/// // Apple
/// final result = await _auth.signInWithApple(nonce: serverChallenge.nonce);
/// ```
class SocialAuthService extends GetxService {
  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void>? _googleInitialization;

  Future<SocialAuthService> init() async {
    try {
      await (_googleInitialization ??= GoogleSignIn.instance.initialize(
        serverClientId: const String.fromEnvironment(
          'GOOGLE_WEB_CLIENT_ID',
          defaultValue:
              '957547435039-9c74psr8j7h9ijve5adc438ktphmqom3.apps.googleusercontent.com',
        ),
      ));
    } catch (_) {
      _googleInitialization = null;
      rethrow;
    }
    return this;
  }

  // ── Google ────────────────────────────────────────────────────────────────

  /// Signs in with Google.
  ///
  /// Returns a [SocialAuthResult] — check [SocialAuthResult.isSuccess]
  /// before reading [SocialAuthResult.user].
  Future<SocialAuthResult> signInWithGoogle() async {
    try {
      await init();
      const scopes = <String>[
        'https://www.googleapis.com/auth/userinfo.email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ];
      final googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: scopes,
      );
      final authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes) ??
          await googleUser.authorizationClient.authorizeScopes(scopes);
      if (authorization.accessToken.trim().isEmpty) {
        return SocialAuthResult.failure(
          'Google did not return an access token. Please try again.',
        );
      }
      return SocialAuthResult.success(
        SocialAuthUser(
          provider: SocialProvider.google,
          uid: googleUser.id,
          email: googleUser.email,
          displayName: googleUser.displayName,
          photoUrl: googleUser.photoUrl,
          accessToken: authorization.accessToken,
        ),
      );
    } on GoogleSignInException catch (e) {
      debugPrint(
        '[SocialAuth] Google sign-in error: ${e.code} – ${e.description}',
      );
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return SocialAuthResult.cancelled();
      }
      return SocialAuthResult.failure(e.description ?? _friendlyError(e));
    } catch (e) {
      debugPrint('[SocialAuth] Google sign-in error: $e');
      return SocialAuthResult.failure(_friendlyError(e));
    }
  }

  /// Signs out of Google (clears cached credentials).
  Future<void> signOutGoogle() async {
    if (_googleInitialization == null) return;
    try {
      await _googleInitialization;
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      debugPrint('[SocialAuth] Google sign-out error: $e');
    }
  }

  // ── Apple ─────────────────────────────────────────────────────────────────

  /// Returns true when Apple Sign-In is available on the current platform/OS.
  ///
  /// Apple Sign-In is supported on:
  ///  • iOS 13+
  ///  • macOS 10.15+
  ///  • Android (via web-based flow, supported by sign_in_with_apple package)
  Future<bool> get isAppleSignInAvailable async {
    if (Platform.isIOS || Platform.isMacOS) {
      return SignInWithApple.isAvailable();
    }
    // Android needs a registered Services ID and callback, not configured here.
    return false;
  }

  /// Signs in with Apple.
  ///
  /// Returns a [SocialAuthResult] — check [SocialAuthResult.isSuccess]
  /// before reading [SocialAuthResult.user].
  Future<SocialAuthResult> signInWithApple({required String nonce}) async {
    try {
      if (!Platform.isIOS && !Platform.isMacOS) {
        return SocialAuthResult.failure(
          'Apple sign-in is currently available on Apple devices only.',
        );
      }
      if (!await SignInWithApple.isAvailable()) {
        return SocialAuthResult.failure(
          'Apple sign-in is unavailable on this device.',
        );
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        nonce: nonce,
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Apple only returns name on the very first sign-in.
      final displayName = [
        credential.givenName,
        credential.familyName,
      ].where((s) => s != null && s.isNotEmpty).join(' ');

      final user = SocialAuthUser(
        provider: SocialProvider.apple,
        uid: credential.userIdentifier ?? '',
        email: credential.email,
        displayName: displayName.isEmpty ? null : displayName,
        photoUrl: null,
        idToken: credential.identityToken,
        authorizationCode: credential.authorizationCode,
      );

      debugPrint('[SocialAuth] Apple sign-in success: ${user.uid}');
      return SocialAuthResult.success(user);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return SocialAuthResult.cancelled();
      }
      debugPrint('[SocialAuth] Apple sign-in error: ${e.message}');
      return SocialAuthResult.failure(e.message);
    } catch (e) {
      debugPrint('[SocialAuth] Apple sign-in error: $e');
      return SocialAuthResult.failure(_friendlyError(e));
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Please try again.';
    }
    if (msg.contains('cancelled') || msg.contains('canceled')) {
      return 'Sign-in was cancelled.';
    }
    return 'Something went wrong. Please try again.';
  }
}

// ─── Data models ──────────────────────────────────────────────────────────────

enum SocialProvider { google, apple }

/// The authenticated user returned after a successful social sign-in.
class SocialAuthUser {
  /// Apple's single-use authorization code, kept only for the backend exchange.
  final String? authorizationCode;
  final SocialProvider provider;

  /// Provider-specific unique user ID.
  final String uid;

  /// May be null if the user chose to hide their email (Apple).
  final String? email;

  /// Display name — only returned on first Apple sign-in.
  final String? displayName;

  /// Profile photo URL (Google only).
  final String? photoUrl;

  /// JWT identity token.
  final String? idToken;

  /// OAuth access / authorization code.
  final String? accessToken;

  const SocialAuthUser({
    this.authorizationCode,
    required this.provider,
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
    this.accessToken,
  });
}

/// Sealed-style result returned by every sign-in method.
class SocialAuthResult {
  final SocialAuthUser? user;
  final String? errorMessage;
  final _SocialAuthStatus _status;

  const SocialAuthResult._({
    required _SocialAuthStatus status,
    this.user,
    this.errorMessage,
  }) : _status = status; // ignore: prefer_initializing_formals

  factory SocialAuthResult.success(SocialAuthUser user) =>
      SocialAuthResult._(status: _SocialAuthStatus.success, user: user);

  factory SocialAuthResult.failure(String? message) => SocialAuthResult._(
    status: _SocialAuthStatus.failure,
    errorMessage: message ?? 'An error occurred.',
  );

  factory SocialAuthResult.cancelled() =>
      SocialAuthResult._(status: _SocialAuthStatus.cancelled);

  bool get isSuccess => _status == _SocialAuthStatus.success;
  bool get isFailure => _status == _SocialAuthStatus.failure;
  bool get isCancelled => _status == _SocialAuthStatus.cancelled;

  /// Convenience handler — mirrors Dart's pattern-matching style.
  ///
  /// ```dart
  /// result.fold(
  ///   onSuccess:   (user) => navigateHome(user),
  ///   onFailure:   (msg)  => showError(msg),
  ///   onCancelled: ()     => {},   // optional
  /// );
  /// ```
  T fold<T>({
    required T Function(SocialAuthUser user) onSuccess,
    required T Function(String message) onFailure,
    T Function()? onCancelled,
  }) {
    switch (_status) {
      case _SocialAuthStatus.success:
        return onSuccess(user!);
      case _SocialAuthStatus.failure:
        return onFailure(errorMessage!);
      case _SocialAuthStatus.cancelled:
        return onCancelled != null
            ? onCancelled()
            : onFailure('Sign-in was cancelled.');
    }
  }
}

enum _SocialAuthStatus { success, failure, cancelled }
