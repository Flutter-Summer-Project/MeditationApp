import 'package:meditation_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/screens/home_screen.dart';
import 'package:meditation_app/screens/session_screen.dart';
import 'package:meditation_app/screens/post_session_screen.dart';
import 'package:meditation_app/screens/session_preferences_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../themes/dark_theme.dart';
import '../themes/light_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meditation_app/localization.dart';

class MeditationApp extends ConsumerStatefulWidget {
  const MeditationApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MeditationAppState? state = context.findAncestorStateOfType<_MeditationAppState>();
    state?.setState(() {
      state._locale = newLocale;
    });
  }

  @override
  ConsumerState<MeditationApp> createState() => _MeditationAppState();
}

class _MeditationAppState extends ConsumerState<MeditationApp> {
  Locale? _locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Localization.of(context)?.translate('app_title') ?? 'Meditation Helper',
      locale: _locale,
      localizationsDelegates: [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('ru')],
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ref.watch(themeProvider),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/session_preferences': (context) => const SessionPreferencesScreen(),
        '/session': (context) => const SessionScreen(),
        '/post_session': (context) => const PostSessionScreen(),
      },
    );
  }
}

