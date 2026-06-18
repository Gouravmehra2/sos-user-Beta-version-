import 'package:get/get.dart';
import 'package:squadonsite/translations/en.dart';
import 'package:squadonsite/translations/es.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en,
        'es_ES': es,
      };
}
