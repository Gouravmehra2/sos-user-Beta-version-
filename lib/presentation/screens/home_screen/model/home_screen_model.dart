/// A single saved address entry as returned by GET /api/auth/me
class UserAddress {
  final String id;
  final String label; // "Home", "Work", "Other"
  final String name;
  final String addressLine;
  final String city;
  final String state;
  final String zipcode;
  final bool isDefault;
  final double? latitude;
  final double? longitude;
  final String? house;
  final String? building;
  final String? area;
  final String? addressType;

  const UserAddress({
    required this.id,
    required this.label,
    this.name = '',
    required this.addressLine,
    required this.city,
    required this.state,
    required this.zipcode,
    this.isDefault = false,
    this.latitude,
    this.longitude,
    this.house,
    this.building,
    this.area,
    this.addressType,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
    id: json['_id'] as String? ?? json['id'] as String? ?? '',
    label: json['label'] as String? ?? 'Other',
    name: json['name'] as String? ?? '',
    addressLine: json['addressLine'] as String? ?? '',
    city: json['city'] as String? ?? '',
    state: json['state'] as String? ?? '',
    zipcode: json['zipcode'] as String? ?? '',
    isDefault: json['isDefault'] == true,
    latitude: _coordinate(json, 'lat', 'latitude', 90),
    longitude: _coordinate(json, 'lng', 'longitude', 180),
    house: json['house'] as String? ?? json['buildingFloor'] as String?,
    building: json['building'] as String? ?? json['street'] as String?,
    area: json['area'] as String? ?? json['addressLine'] as String?,
    addressType: json['addressType'] as String?,
  );

  static double? _coordinate(
    Map<String, dynamic> json,
    String key,
    String legacyKey,
    double limit,
  ) {
    final coordinates = json['coordinates'];
    final value = coordinates is Map ? coordinates[key] : null;
    final number = double.tryParse('${value ?? json[legacyKey]}');
    return number != null && number.isFinite && number.abs() <= limit
        ? number
        : null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'isDefault': isDefault,
    'label': label,
    'name': name,
    'addressLine': addressLine,
    'city': city,
    'state': state,
    'zipcode': zipcode,
    if (latitude != null && longitude != null)
      'coordinates': {'lat': latitude, 'lng': longitude},
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
    'buildingFloor': ?house,
    'street': ?building,
    'house': ?house,
    'building': ?building,
    'area': ?area,
    'addressType': ?addressType,
  };

  /// Human-readable single-line address.
  String get displayAddress {
    final parts = [
      house ?? '',
      building ?? '',
      addressLine,
      city,
      state,
      zipcode,
    ].where((p) => p.isNotEmpty).toList();
    return parts.join(', ');
  }
}

class HomeProfileResponse {
  final bool success;
  final HomeProfileData data;

  const HomeProfileResponse({required this.success, required this.data});

  factory HomeProfileResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as Map<String, dynamic>? ?? const {};
    return HomeProfileResponse(
      success: json['success'] == true,
      data: HomeProfileData.fromJson(dataJson),
    );
  }
}

class HomeProfileData {
  final HomeProfileUser user;

  const HomeProfileData({required this.user});

  factory HomeProfileData.fromJson(Map<String, dynamic> json) {
    return HomeProfileData(
      user: HomeProfileUser.fromJson(
        (json['user'] as Map<String, dynamic>?) ?? const {},
      ),
    );
  }
}

class HomeProfileUser {
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
  final HomeProfileImage profileImage;
  final int totalJobsDone;
  final num totalEarnings;
  final num totalWithdrawn;
  final List<dynamic> cart;
  final List<dynamic> certifications;
  final List<dynamic> skills;
  final List<dynamic> fcmToken;
  final List<UserAddress> addresses;
  final String selectedAddressId;
  final String createdAt;
  final String updatedAt;

  const HomeProfileUser({
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
    this.profileImage = const HomeProfileImage(),
    this.totalJobsDone = 0,
    this.totalEarnings = 0,
    this.totalWithdrawn = 0,
    this.cart = const [],
    this.certifications = const [],
    this.skills = const [],
    this.fcmToken = const [],
    this.addresses = const [],
    this.selectedAddressId = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  UserAddress? get defaultAddress {
    for (final address in addresses) {
      if (selectedAddressId.isNotEmpty && address.id == selectedAddressId) {
        return address;
      }
    }
    for (final address in addresses) {
      if (address.isDefault) return address;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  factory HomeProfileUser.fromJson(Map<String, dynamic> json) {
    final imageJson = json['profileImage'] as Map<String, dynamic>? ?? const {};

    return HomeProfileUser(
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
      profileImage: HomeProfileImage.fromJson(imageJson),
      totalJobsDone: (json['totalJobsDone'] as num?)?.toInt() ?? 0,
      totalEarnings: (json['totalEarnings'] as num?) ?? 0,
      totalWithdrawn: (json['totalWithdrawn'] as num?) ?? 0,
      cart: (json['cart'] as List<dynamic>?) ?? const [],
      certifications: (json['certifications'] as List<dynamic>?) ?? const [],
      skills: (json['skills'] as List<dynamic>?) ?? const [],
      fcmToken: (json['fcmToken'] as List<dynamic>?) ?? const [],
      addresses: ((json['addresses'] as List<dynamic>?) ?? [])
          .map((e) => UserAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedAddressId: json['selectedAddressId'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }
}

class HomeProfileImage {
  final String url;
  final String s3Key;

  const HomeProfileImage({this.url = '', this.s3Key = ''});

  factory HomeProfileImage.fromJson(Map<String, dynamic> json) {
    return HomeProfileImage(
      url: json['url'] as String? ?? '',
      s3Key: json['s3Key'] as String? ?? '',
    );
  }
}
