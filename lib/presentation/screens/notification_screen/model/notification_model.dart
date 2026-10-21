import 'package:squadonsite/core/pagination/pagination_info.dart';

class NotificationResponse {
  final bool success;
  final NotificationResponseData data;

  const NotificationResponse({required this.success, required this.data});

  factory NotificationResponse.fromJson(
    Map<String, dynamic> json, {
    int page = 1,
    int limit = 10,
  }) {
    return NotificationResponse(
      success: json['success'] == true,
      data: NotificationResponseData.fromJson(
        _map(json['data']),
        response: json,
        page: page,
        limit: limit,
      ),
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'data': data.toJson()};
}

class NotificationResponseData {
  final List<AppNotification> notifications;
  final int unreadCount;
  final bool hasMore;

  const NotificationResponseData({
    required this.notifications,
    required this.unreadCount,
    this.hasMore = false,
  });

  factory NotificationResponseData.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? response,
    int page = 1,
    int limit = 10,
  }) {
    final rawNotifications = json['notifications'] as List<dynamic>? ?? [];
    final notifications = rawNotifications
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
    return NotificationResponseData(
      notifications: notifications,
      unreadCount: _int(json['unreadCount']),
      hasMore: PaginationInfo.fromResponse(
        response: response ?? json,
        data: json,
        page: page,
        limit: limit,
        itemCount: notifications.length,
      ).hasMore,
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications.map((item) => item.toJson()).toList(),
    'unreadCount': unreadCount,
  };
}

class AppNotification {
  final String id;
  final String recipient;
  final String recipientModel;
  final String sender;
  final String senderModel;
  final String type;
  final String title;
  final String message;
  final NotificationDetails data;
  final bool isRead;
  final int v;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AppNotification({
    required this.id,
    required this.recipient,
    required this.recipientModel,
    required this.sender,
    required this.senderModel,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.isRead,
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: _string(json['_id']),
      recipient: _string(json['recipient']),
      recipientModel: _string(json['recipientModel']),
      sender: _string(json['sender']),
      senderModel: _string(json['senderModel']),
      type: _string(json['type']),
      title: _string(json['title']),
      message: _string(json['message']),
      data: NotificationDetails.fromJson(_map(json['data'])),
      isRead: json['isRead'] == true,
      v: _int(json['v']),
      createdAt: _date(json['createdAt']),
      updatedAt: _date(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'recipient': recipient,
    'recipientModel': recipientModel,
    'sender': sender,
    'senderModel': senderModel,
    'type': type,
    'title': title,
    'message': message,
    'data': data.toJson(),
    'isRead': isRead,
    'v': v,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}

class NotificationDetails {
  final String bookingId;
  final String status;
  final String technicianName;
  final String technicianPhone;

  const NotificationDetails({
    required this.bookingId,
    required this.status,
    required this.technicianName,
    required this.technicianPhone,
  });

  factory NotificationDetails.fromJson(Map<String, dynamic> json) {
    return NotificationDetails(
      bookingId: _string(json['bookingId']),
      status: _string(json['status']),
      technicianName: _string(json['technicianName']),
      technicianPhone: _string(json['technicianPhone']),
    );
  }

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'status': status,
    'technicianName': technicianName,
    'technicianPhone': technicianPhone,
  };
}

Map<String, dynamic> _map(dynamic value) =>
    value is Map<String, dynamic> ? value : <String, dynamic>{};

String _string(dynamic value) => value?.toString() ?? '';

int _int(dynamic value) => value is num ? value.toInt() : 0;

DateTime? _date(dynamic value) =>
    value is String ? DateTime.tryParse(value) : null;
