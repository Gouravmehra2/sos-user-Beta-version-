import 'package:squadonsite/translations/ar.dart';
import 'package:get/get.dart';
import 'package:squadonsite/translations/en.dart';
import 'package:squadonsite/translations/es.dart';

class AppTranslations extends Translations {
  Map<String, String> _withDisplayAliases(Map<String, String> locale) {
    final result = Map<String, String>.from(locale);
    // Static UI models and legacy validators may still hold a displayed value.
    // Resolve those values at render time, including after a locale change.
    for (final entry in en.entries) {
      final value = locale[entry.key] ?? entry.value;
      for (final source in [en, es, ar]) {
        final alias = source[entry.key];
        if (alias != null && alias.isNotEmpty) {
          result.putIfAbsent(alias, () => value);
        }
      }
    }
    for (final status in [
      'Pending',
      'Completed',
      'Confirmed',
      'Cancelled',
      'Paid',
      'Unpaid',
      'Failed',
      'Active',
      'Expired',
      'Replaced',
      'Assigned',
      'In Progress',
      'On the Way',
    ]) {
      final value = result[status] ?? status;
      result.putIfAbsent(status.toUpperCase(), () => value);
    }
    return result;
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': _withDisplayAliases(en),
    'es_ES': _withDisplayAliases(es),
    'ar_AE': _withDisplayAliases(ar),
  };
}
