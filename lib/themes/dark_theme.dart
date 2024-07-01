import 'package:flutter/material.dart';

var darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlueAccent,
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: const AppBarTheme(
        color: Colors.lightBlueAccent
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
                  (Set<WidgetState> states) => Colors.lightBlueAccent,
            ),
            shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
            )
        )
    ),
    scaffoldBackgroundColor: Colors.black87
);
