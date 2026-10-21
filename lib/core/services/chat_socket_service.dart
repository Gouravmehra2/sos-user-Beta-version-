import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:squadonsite/core/end_points/api_endpoints.dart';

typedef ChatSocketMessageHandler = void Function(Map<String, dynamic> message);
typedef ChatSocketTypingHandler = void Function(bool isTyping);
typedef ChatSocketStateHandler = void Function(bool connected);

class ChatSocketService {
  io.Socket? _socket;
  String _userId = '';
  ChatSocketMessageHandler? _onMessage;
  ChatSocketTypingHandler? _onTyping;
  ChatSocketStateHandler? _onStateChanged;

  bool get isConnected => _socket?.connected == true;

  void connect({
    required String accessToken,
    required String userId,
    required ChatSocketMessageHandler onMessage,
    required ChatSocketTypingHandler onTyping,
    required ChatSocketStateHandler onStateChanged,
  }) {
    disconnect();
    _userId = userId;
    _onMessage = onMessage;
    _onTyping = onTyping;
    _onStateChanged = onStateChanged;
    final socket = io.io(
      _socketOrigin(ApiEndpoints.baseUrl),
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .setAuth({'token': accessToken})
          .disableAutoConnect()
          .build(),
    );
    _socket = socket;
    socket.onConnect((_) {
      _onStateChanged?.call(true);
      socket.emit('chat:join', _roomPayload());
    });
    socket.onDisconnect((_) => _onStateChanged?.call(false));
    socket.onConnectError((_) => _onStateChanged?.call(false));
    socket.on('chat:message', _handleMessage);
    socket.on('chat:typing', _handleTyping);
    socket.connect();
  }

  void sendText(
    String text, {
    required void Function(bool success, String? error) onAck,
  }) {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      onAck(false, 'Chat is offline. Please try again.');
      return;
    }
    socket.emitWithAck(
      'chat:send',
      {..._roomPayload(), 'text': text},
      ack: (dynamic response) {
        final data = _asMap(response);
        final success = data['success'] == true && data['message'] is Map;
        onAck(success, success ? null : data['message']?.toString());
      },
    );
  }

  void sendTyping(bool isTyping) {
    if (!isConnected) return;
    _socket?.emit('chat:typing', {..._roomPayload(), 'isTyping': isTyping});
  }

  void disconnect() {
    final socket = _socket;
    if (socket == null) return;
    if (socket.connected) socket.emit('chat:leave', _roomPayload());
    socket.off('chat:message');
    socket.off('chat:typing');
    socket.disconnect();
    socket.dispose();
    _socket = null;
  }

  Map<String, dynamic> _roomPayload() => {
    'participantType': 'user',
    'participantId': _userId,
  };

  void _handleMessage(dynamic payload) {
    final data = _asMap(payload);
    final message = _asMap(data['message']);
    if (message['participantType'] == 'user' &&
        message['participantId']?.toString() == _userId) {
      _onMessage?.call(message);
    }
  }

  void _handleTyping(dynamic payload) {
    final data = _asMap(payload);
    if (data['participantType'] == 'user' &&
        data['participantId']?.toString() == _userId &&
        data['senderRole'] == 'admin') {
      _onTyping?.call(data['isTyping'] == true);
    }
  }

  static Map<String, dynamic> _asMap(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  static String _socketOrigin(String baseUrl) {
    final uri = Uri.parse(baseUrl);
    final path = uri.path.endsWith('/api')
        ? uri.path.substring(0, uri.path.length - 4)
        : uri.path;
    return Uri(
      scheme: uri.scheme,
      userInfo: uri.userInfo,
      host: uri.host,
      port: uri.port,
      path: path,
    ).toString();
  }
}
