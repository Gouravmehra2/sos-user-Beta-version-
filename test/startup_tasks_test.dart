import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:squadonsite/core/startup/startup_tasks.dart';

void main() {
  testWidgets('optional startup work runs once after a destination frame', (tester) async {
    var calls = 0;
    final tasks = StartupTasks(initializeNotifications: () async { calls++; });
    tasks.schedule();
    tasks.schedule();
    expect(calls, 0);
    await tester.pumpWidget(const SizedBox());
    SchedulerBinding.instance.handleEventLoopCallback();
    await tester.pump();
    expect(calls, 1);
    tasks.schedule();
    await tester.pump();
    expect(calls, 1);
  });
}
