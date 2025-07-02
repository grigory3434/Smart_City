import 'package:flutter/material.dart';

// Enum для языков
enum AppLanguage {
  ru,
  en,
}

// Провайдер для локали
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['ru', 'en'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('ru');
    notifyListeners();
  }
}
