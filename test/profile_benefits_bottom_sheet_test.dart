import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:squadonsite/core/services/auth_api_service.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_controller.dart';
import 'package:squadonsite/presentation/screens/profile_screen/profile_screen.dart';
import 'package:squadonsite/translations/app_translations.dart';

void main() {
  testWidgets('tapping view benefits opens the benefits bottom sheet', (tester) async {
    Get.put(AuthSession());
    Get.put(ProfileController());

    await tester.pumpWidget(
      GetMaterialApp(
        locale: const Locale('en', 'US'),
        translations: AppTranslations(),
        home: ProfileScreen(),
      ),
    );

    await tester.tap(find.text('View Benefits'));
    await tester.pumpAndSettle();

    expect(find.text('Best deal'), findsOneWidget);
    expect(find.text('Pro SOS Plan'), findsOneWidget);
    expect(find.text('Subscribe Now'), findsOneWidget);
  });
}
