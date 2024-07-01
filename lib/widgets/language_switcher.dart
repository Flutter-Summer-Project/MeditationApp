import 'package:flutter/material.dart';
import 'package:meditation_app/localization.dart';
import 'meditation_app.dart';


class LanguageSwitcher extends StatefulWidget {
  @override
  _LanguageSwitcherState createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  Locale? _currentLocale;
  Localization? _localization;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentLocale = Localizations.localeOf(context);
    _localization = Localization.of(context);
  }

  void _changeLanguage(Locale locale) async {
    await _localization!.load();
    MeditationApp.setLocale(context, locale);
    setState(() {
      _currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_currentLocale == const Locale('en')) {
          _changeLanguage(const Locale('ru'));
        } else {
          _changeLanguage(const Locale('en'));
        }
      },
      child: const Icon(Icons.language),
    );
  }
}


