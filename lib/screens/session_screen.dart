import 'package:meditation_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/timer_widget.dart';
import 'package:meditation_app/widgets/language_switcher.dart';
import 'package:meditation_app/localization.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          appBar: DefaultAppBar(title: Localization.of(context)?.translate('meditation') ?? 'Meditation', ref: ref),
          body: Container(
            child: const Timerwidget(),
          ),
          floatingActionButton: LanguageSwitcher(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        );
      },
    );
  }
}
