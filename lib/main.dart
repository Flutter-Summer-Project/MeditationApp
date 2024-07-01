import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'widgets/meditation_app.dart';
import 'package:meditation_app/boxes.dart';

void main() async {
  await Hive.initFlutter();
  sessionsBox = await Hive.openBox<String>('session_box');

  runApp(const ProviderScope(
    child: MeditationApp(),
  ));
}
