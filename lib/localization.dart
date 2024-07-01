import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static const LocalizationsDelegate<Localization> delegate =
      _LocalizationDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.arb');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    final translated = _localizedStrings[key];
    print('$key -> $translated');
    return translated ?? key;
  }
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ru'].contains(locale.languageCode);

  @override
  Future<Localization> load(Locale locale) async {
    Localization localization = Localization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_LocalizationDelegate old) => true;
}

