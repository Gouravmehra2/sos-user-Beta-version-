import 'dart:io';

import 'firebase_notification_service.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
/// final result = await _auth.signInWithApple();
/// ```
class SocialAuthService extends GetxService {
  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void>? _googleInitialization;

  Future<SocialAuthService> init() async {
    try {
      await (_googleInitialization ??= GoogleSignIn.instance.initialize());
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
      // authenticate() triggers the interactive sign-in UI.
      final googleUser = await GoogleSignIn.instance.authenticate();

      final googleIdToken = googleUser.authentication.idToken;

      print('--=-=->> ${googleIdToken}');
      if (googleIdToken == null || googleIdToken.isEmpty) {
        return SocialAuthResult.failure(
          'Google did not return an identity token. Please try again.',
        );
      }
      await FirebaseNotificationService.ensureFirebase();
      final credential = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(idToken: googleIdToken),
      );
      final firebaseUser = credential.user;
      final firebaseIdToken = await firebaseUser?.getIdToken(true);
      if (firebaseUser == null ||
          firebaseIdToken == null ||
          firebaseIdToken.isEmpty) {
        return SocialAuthResult.failure(
          'Unable to verify your Google account. Please try again.',
        );
      }
      final user = SocialAuthUser(
        provider: SocialProvider.google,
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoUrl: firebaseUser.photoURL,
        firebaseIdToken: firebaseIdToken,
      );
      return SocialAuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return SocialAuthResult.failure(switch (e.code) {
        'network-request-failed' => 'No internet connection. Please try again.',
        'user-disabled' => 'This account has been disabled.',
        'account-exists-with-different-credential' =>
          'This email uses a different sign-in method. Please use that method.',
        'operation-not-allowed' =>
          'Google sign-in is not enabled. Please contact support.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        _ => 'Unable to verify your Google account. Please try again.',
      });
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
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('[SocialAuth] Firebase sign-out failed: $e');
    }
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
    // Android: always allow — the package handles the web-based flow.
    return Platform.isAndroid;
  }

  /// Signs in with Apple.
  ///
  /// Returns a [SocialAuthResult] — check [SocialAuthResult.isSuccess]
  /// before reading [SocialAuthResult.user].
  Future<SocialAuthResult> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
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
        accessToken: credential.authorizationCode,
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

  /// Firebase ID token for the Firebase-aware backend contract.
  final String? firebaseIdToken;

  const SocialAuthUser({
    required this.provider,
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
    this.accessToken,
    this.firebaseIdToken,
  });
}

/// Sealed-style result returned by every sign-in method.
class SocialAuthResult {
  final SocialAuthUser? user;
  final String? errorMessage;
  // ignore: prefer_initializing_formals
  final _SocialAuthStatus _status;

  const SocialAuthResult._({
    required _SocialAuthStatus status,
    this.user,
    this.errorMessage,
  }) : _status = status;

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
