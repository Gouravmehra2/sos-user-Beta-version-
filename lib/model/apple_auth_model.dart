import 'auth_model.dart';

class AppleChallenge {
  final String nonce;
  final String token;
  const AppleChallenge({required this.nonce, required this.token});
}

/// Short-lived ticket; never persist this object or include it in logs.
class AppleRegistration {
  final String email;
  final String token;
  final String name;
  final DateTime expiresAt;

  AppleRegistration({
    required this.email,
    required this.token,
    this.name = '',
    DateTime? expiresAt,
  }) : expiresAt = expiresAt ?? DateTime.now().add(const Duration(minutes: 10));

  bool get isExpired => !DateTime.now().isBefore(expiresAt);

  AppleRegistration withName(String value) => AppleRegistration(
    email: email,
    token: token,
    name: value,
    expiresAt: expiresAt,
  );
}

class AppleLoginResult {
  final AuthResponse? session;
  final AppleRegistration? registration;
  const AppleLoginResult.session(AuthResponse value)
    : session = value,
      registration = null;
  const AppleLoginResult.registration(AppleRegistration value)
    : registration = value,
      session = null;
}
