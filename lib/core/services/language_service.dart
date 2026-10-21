import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Arabic uses the UAE locale for customers in Dubai.
enum AppLanguage { english, spanish, arabic }

class LanguageService extends GetxController {
  static LanguageService get to => Get.find<LanguageService>();

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('ar', 'AE'),
  ];

  final Rx<AppLanguage> currentLanguage = AppLanguage.english.obs;
  static const preferenceKey = 'app_language';
  SharedPreferences? _preferences;
  bool _refreshScheduled = false;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    final saved = _preferences!.getString(preferenceKey);
    currentLanguage.value = AppLanguage.values.firstWhere(
      (language) => language.name == saved,
      orElse: () => AppLanguage.english,
    );
    Get.locale = locale;
  }

  Locale get locale => supportedLocales[currentLanguage.value.index];

  Future<void> setLanguage(AppLanguage language) async {
    currentLanguage.value = language;
    Get.locale = locale;
    Get.appUpdate();
    // Some existing screens use .tr without listening to Localizations.
    // Rebuild mounted routes, including offstage tabs, while retaining their
    // controllers, navigation stack, scroll positions and form state.
    if (!_refreshScheduled) {
      _refreshScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshScheduled = false;
        void rebuild(Element element) {
          element.markNeedsBuild();
          element.visitChildren(rebuild);
        }

        WidgetsBinding.instance.rootElement?.visitChildren(rebuild);
      });
      WidgetsBinding.instance.scheduleFrame();
    }
    try {
      final preferences = _preferences ??=
          await SharedPreferences.getInstance();
      await preferences.setString(preferenceKey, currentLanguage.value.name);
    } catch (error) {
      debugPrint('Unable to save language preference: $error');
    }
  }

  void setEnglish() => setLanguage(AppLanguage.english);
  void setSpanish() => setLanguage(AppLanguage.spanish);
  void setArabic() => setLanguage(AppLanguage.arabic);

  void toggleLanguage() => setLanguage(
    AppLanguage.values[(currentLanguage.value.index + 1) %
        AppLanguage.values.length],
  );

  String get currentLanguageLabel => _labels[currentLanguage.value.index];
  String get switchLanguageLabel =>
      _labels[(currentLanguage.value.index + 1) % _labels.length];

  static const _labels = ['English', 'Español', 'العربية'];
}
