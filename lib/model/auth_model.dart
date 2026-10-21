class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'password': password,
  };
}

class VerifyRegisterRequest {
  final String phone;
  final String code;

  const VerifyRegisterRequest({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {'phone': phone, 'code': code};
}

class LoginRequest {
  final String email;
  final String password;
  final String? phone;

  const LoginRequest({this.email = '', required this.password, this.phone});

  Map<String, dynamic> toJson() => {
    if (email.trim().isNotEmpty) 'email': email.trim(),
    if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
    'password': password,
  };
}

class AuthResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final String expiresIn;
  final String phone;
  final String devOtp;
  final AuthUser? user;

  const AuthResponse({
    required this.success,
    this.message = '',
    this.accessToken = '',
    this.refreshToken = '',
    this.expiresIn = '',
    this.phone = '',
    this.devOtp = '',
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final userJson = data?['user'] as Map<String, dynamic>?;
    return AuthResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      accessToken:
          json['accessToken'] as String? ??
          data?['accessToken'] as String? ??
          '',
      refreshToken:
          json['refreshToken'] as String? ??
          data?['refreshToken'] as String? ??
          '',
      expiresIn: json['expiresIn'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      devOtp: json['devOtp'] as String? ?? '',
      user: userJson == null ? null : AuthUser.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'expiresIn': expiresIn,
    if (phone.isNotEmpty) 'phone': phone,
    if (devOtp.isNotEmpty) 'devOtp': devOtp,
    if (user != null) 'data': {'user': user!.toJson()},
  };
}

class AuthUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String accountStatus;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final bool profileCompleted;
  final String profileImageUrl;
  final String dateOfBirth;
  final String gender;
  final String alternateContact;
  final List<dynamic> skills;
  final List<dynamic> certifications;
  final List<dynamic> cart;
  final Map<String, dynamic> bankDetails;
  final Map<String, dynamic> technicianProfile;
  final Map<String, dynamic> profileImage;
  final int totalJobsDone;
  final num totalEarnings;
  final num totalWithdrawn;
  final List<dynamic> fcmToken;
  final String createdAt;
  final String updatedAt;

  const AuthUser({
    this.id = '',
    this.name = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.role = '',
    this.accountStatus = '',
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
    this.profileCompleted = false,
    this.profileImageUrl = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.alternateContact = '',
    this.skills = const [],
    this.certifications = const [],
    this.cart = const [],
    this.bankDetails = const {},
    this.technicianProfile = const {},
    this.profileImage = const {},
    this.totalJobsDone = 0,
    this.totalEarnings = 0,
    this.totalWithdrawn = 0,
    this.fcmToken = const [],
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final profileImage = json['profileImage'] as Map<String, dynamic>?;
    return AuthUser(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      address: json['address'] as String? ?? '',
      role: json['role'] as String? ?? '',
      accountStatus: json['accountStatus'] as String? ?? '',
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      profileCompleted: json['profileCompleted'] as bool? ?? false,
      profileImageUrl: profileImage?['url'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      alternateContact: json['alternateContact'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>?) ?? const [],
      certifications: (json['certifications'] as List<dynamic>?) ?? const [],
      cart: (json['cart'] as List<dynamic>?) ?? const [],
      bankDetails: _map(json['bankDetails']),
      technicianProfile: _map(json['technicianProfile']),
      profileImage: _map(json['profileImage']),
      totalJobsDone: (json['totalJobsDone'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?) ?? 0,
      totalWithdrawn: (json['totalWithdrawn'] as num?) ?? 0,
      fcmToken: (json['fcmToken'] as List<dynamic>?) ?? const [],
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'address': address,
    'role': role,
    'accountStatus': accountStatus,
    'isPhoneVerified': isPhoneVerified,
    'isEmailVerified': isEmailVerified,
    'profileCompleted': profileCompleted,
    'profileImage': profileImage,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'alternateContact': alternateContact,
    'skills': skills,
    'certifications': certifications,
    'cart': cart,
    'bankDetails': bankDetails,
    'technicianProfile': technicianProfile,
    'totalJobsDone': totalJobsDone,
    'totalEarnings': totalEarnings,
    'totalWithdrawn': totalWithdrawn,
    'fcmToken': fcmToken,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  static Map<String, dynamic> _map(Object? value) =>
      value is Map<String, dynamic> ? value : <String, dynamic>{};
}
