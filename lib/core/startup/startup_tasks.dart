import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Runs optional native setup once the destination screen can render and
/// route animations no longer occupy the frame scheduler.
class StartupTasks {
  StartupTasks({required this.initializeNotifications});

  final Future<void> Function() initializeNotifications;
  bool _scheduled = false;

  void schedule() {
    if (_scheduled) return;
    _scheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      unawaited(SchedulerBinding.instance.scheduleTask(() async {
        try {
          await initializeNotifications();
        } catch (error) {
          if (kDebugMode) debugPrint('Notification initialization failed: $error');
        }
      }, Priority.idle, debugLabel: 'Optional notification setup'));
    });
  }
}
