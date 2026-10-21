import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/app_color/app_color.dart';
import 'package:squadonsite/constant/common_widgets/app_snackbar.dart';

void main() {
  Future<void> expectSnackbarTheme(
    WidgetTester tester, {
    required ThemeData theme,
    required Color background,
    required Color foreground,
  }) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: theme,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => AppSnackbar.show('Notice', 'Message'),
              child: const Text('Show notice'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Show notice'));
    await tester.pump();

    final snackbar = tester.widget<GetSnackBar>(find.byType(GetSnackBar));
    expect(snackbar.snackPosition, SnackPosition.TOP);
    expect(snackbar.backgroundColor, background);
    expect((snackbar.titleText as Text).style?.color, foreground);
    expect((snackbar.messageText as Text).style?.color, foreground);

    Get.closeCurrentSnackbar();
    await tester.pumpAndSettle();
  }

  testWidgets('uses black with white text in the light theme', (tester) async {
    await expectSnackbarTheme(
      tester,
      theme: ThemeData.light(),
      background: AppColor.blackColor,
      foreground: Colors.white,
    );
  });

  testWidgets('uses white with black text in the dark theme', (tester) async {
    await expectSnackbarTheme(
      tester,
      theme: ThemeData.dark(),
      background: Colors.white,
      foreground: AppColor.blackColor,
    );
  });
}
