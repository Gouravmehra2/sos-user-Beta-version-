import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/dio_client/dio_client.dart';
import 'package:squadonsite/core/end_points/api_endpoints.dart';
import 'package:squadonsite/core/pagination/pagination_info.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/core/services/chat_socket_service.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String time;
  final String? mediaUrl;
  final String messageType;

  const ChatMessage({
    this.id = '',
    required this.text,
    required this.isUser,
    required this.time,
    this.mediaUrl,
    this.messageType = 'text',
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String userId) {
    final createdAt = DateTime.tryParse(
      json['createdAt']?.toString() ?? '',
    )?.toLocal();
    final media = json['media'] is Map
        ? Map<String, dynamic>.from(json['media'])
        : null;
    return ChatMessage(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      isUser:
          json['senderRole']?.toString() == 'user' ||
          json['senderId']?.toString() == userId,
      time: _formatTime(createdAt),
      mediaUrl: media?['url']?.toString().trim().isEmpty == false
          ? media!['url'].toString().trim()
          : null,
      messageType: json['messageType']?.toString() ?? 'text',
    );
  }

  static String _formatTime(DateTime? date) {
    if (date == null) return '';
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${(date.hour < 12 ? 'AM' : 'PM').tr}';
  }
}

class ChatSupportController extends GetxController {
  static const int _pageSize = 10;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isAgentTyping = false.obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreMessages = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isUploading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;
  final RxBool isConnected = false.obs;
  Timer? _typingTimer;
  int _messagePage = 1;

  late final AuthSession _session;
  late final DioClient _dio;
  late final ChatSocketService _socket;
  String get _userId => _session.user?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    _session = Get.find<AuthSession>();
    _dio = Get.find<DioClient>();
    _socket = Get.find<ChatSocketService>();
    messageController.addListener(_onTextChanged);
    scrollController.addListener(_onMessageScroll);
    _startChat();
  }

  void _onMessageScroll() {
    if (!scrollController.hasClients ||
        scrollController.position.extentAfter > 200) {
      return;
    }
    loadMoreMessages();
  }

  Future<void> _startChat() async {
    if (_userId.isEmpty || !_session.hasToken) {
      isLoading.value = false;
      return;
    }
    _socket.connect(
      accessToken: _session.accessToken,
      userId: _userId,
      onMessage: _addMessage,
      onTyping: (value) => isAgentTyping.value = value,
      onStateChanged: (value) => isConnected.value = value,
    );
    await loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.chatMessages(_userId),
        queryParameters: {'page': 1, 'limit': _pageSize},
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final data = body['data'] is Map
          ? Map<String, dynamic>.from(body['data'])
          : <String, dynamic>{};
      final loaded = (data['messages'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) =>
                ChatMessage.fromJson(Map<String, dynamic>.from(item), _userId),
          )
          .toList();
      messages.assignAll(loaded);
      _messagePage = 1;
      hasMoreMessages.value =
          loaded.isNotEmpty &&
          PaginationInfo.fromResponse(
            response: body,
            data: data,
            page: 1,
            limit: _pageSize,
            itemCount: loaded.length,
          ).hasMore;
      await markAsRead();
      _scrollToBottom();
    } catch (_) {
      _showError("Unable to load chat history.".tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (_userId.isEmpty ||
        isLoading.value ||
        isLoadingMore.value ||
        !hasMoreMessages.value) {
      return;
    }
    isLoadingMore.value = true;
    try {
      final page = _messagePage + 1;
      final response = await _dio.get(
        ApiEndpoints.chatMessages(_userId),
        queryParameters: {'page': page, 'limit': _pageSize},
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final data = body['data'] is Map
          ? Map<String, dynamic>.from(body['data'])
          : <String, dynamic>{};
      final loaded = (data['messages'] as List? ?? [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final knownIds = messages.map((item) => item.id).toSet();
      final newItems = loaded
          .map((item) => ChatMessage.fromJson(item, _userId))
          .where((item) => item.id.isEmpty || knownIds.add(item.id))
          .toList();
      messages.addAll(newItems);
      _messagePage = page;
      hasMoreMessages.value =
          newItems.isNotEmpty &&
          PaginationInfo.fromResponse(
            response: body,
            data: data,
            page: page,
            limit: _pageSize,
            itemCount: loaded.length,
          ).hasMore;
    } catch (_) {
      _showError("Unable to load more chat messages.".tr);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> markAsRead() async {
    if (_userId.isEmpty) return;
    try {
      await _dio.patch(ApiEndpoints.chatRead(_userId));
    } catch (_) {}
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty || text.length > 4000 || isSending.value) return;
    isSending.value = true;
    _socket.sendText(
      text,
      onAck: (success, error) {
        isSending.value = false;
        if (!success) {
          _showError(error ?? "Message was not sent.".tr);
          return;
        }
        messageController.clear();
      },
    );
  }

  Future<void> pickAndSendMedia() async {
    final picked = await _imagePicker.pickMedia();
    if (picked == null) return;
    final file = File(picked.path);
    final size = await file.length();
    final isVideo = _isVideo(picked.path);
    final maxSize = isVideo ? 50 * 1024 * 1024 : 5 * 1024 * 1024;
    if (size > maxSize) {
      _showError(
        isVideo
            ? "Video must be 50 MB or smaller.".tr
            : "Image must be 5 MB or smaller.".tr,
      );
      return;
    }
    try {
      isSending.value = true;
      isUploading.value = true;
      uploadProgress.value = 0;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          picked.path,
          filename: picked.name,
        ),
        if (messageController.text.trim().isNotEmpty)
          'text': messageController.text.trim(),
      });
      final response = await _dio.post(
        ApiEndpoints.chatMessages(_userId),
        data: formData,
        onSendProgress: (sent, total) {
          uploadProgress.value = total > 0 ? sent / total : 0;
        },
      );
      final body = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final data = body['data'] is Map
          ? Map<String, dynamic>.from(body['data'])
          : <String, dynamic>{};
      final message = data['message'];
      if (message is Map) _addMessage(Map<String, dynamic>.from(message));
      messageController.clear();
    } catch (_) {
      _showError("Unable to send attachment.".tr);
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
      isSending.value = false;
    }
  }

  void onEndChat() =>
      Get.toNamed(AppRoutes.supportThankYouScreen, arguments: 'chat');

  void _addMessage(Map<String, dynamic> json) {
    final message = ChatMessage.fromJson(json, _userId);
    if (message.id.isNotEmpty &&
        messages.any((item) => item.id == message.id)) {
      return;
    }
    messages.add(message);
    if (!message.isUser) markAsRead();
    _scrollToBottom();
  }

  void _onTextChanged() {
    if (!isConnected.value) return;
    _socket.sendTyping(messageController.text.trim().isNotEmpty);
    _typingTimer?.cancel();
    if (messageController.text.trim().isNotEmpty) {
      _typingTimer = Timer(
        const Duration(milliseconds: 800),
        () => _socket.sendTyping(false),
      );
    }
  }

  bool _isVideo(String path) => [
    '.mp4',
    '.mov',
    '.m4v',
    '.avi',
    '.webm',
  ].any((extension) => path.toLowerCase().endsWith(extension));

  void _showError(String message) => AppSnackbar.show("Chat".tr, message);

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    _socket.sendTyping(false);
    _socket.disconnect();
    messageController.removeListener(_onTextChanged);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
