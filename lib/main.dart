import 'dart:io';
import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:squadonsite/constant/pages/app_pages.dart';
import 'package:squadonsite/constant/routes/app_routes.dart';
import 'package:squadonsite/core/services/language_service.dart';
import 'package:squadonsite/core/services/social_auth_service.dart';
import 'package:squadonsite/firebase_options.dart';
import 'package:squadonsite/translations/app_translations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  firebaseInitialize();
  handleDeviceOrientation();
  _registerServices();
  runApp(
      const MyApp()
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // builder: DevicePreview.appBuilder,
      defaultTransition:
          Platform.isIOS ? Transition.cupertino : Transition.native,
      transitionDuration: const Duration(milliseconds: 500),
      getPages: AppPages.getPages,
      initialRoute: AppRoutes.splashScreen,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      // ── Localisation ──────────────────────────────────────────────────────
      translations: AppTranslations(),
      locale: Get.find<LanguageService>().locale,
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}

void handleDeviceOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

void firebaseInitialize() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void _registerServices() {
  Get.putAsync(() => SocialAuthService().init(), permanent: true);
  Get.put(LanguageService(), permanent: true);
}
