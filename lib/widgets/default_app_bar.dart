import "package:meditation_app/providers/theme_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class DefaultAppBar extends AppBar {
  DefaultAppBar({required String title, required WidgetRef ref,
    required super.automaticallyImplyLeading, super.key}) : super(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.black,
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: ref.watch(themeProvider.notifier).switchThemeMode,
        icon: (ref.watch(themeProvider) != ThemeMode.light) ?
        const Icon(Icons.light_mode_rounded) :
        const Icon(Icons.dark_mode_rounded),
      )
    ]
  );
}
