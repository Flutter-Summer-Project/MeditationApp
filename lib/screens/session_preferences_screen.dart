import 'package:meditation_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/session_duration_form.dart';
import 'package:meditation_app/widgets/song_selection_widget.dart';
import 'package:meditation_app/widgets/language_switcher.dart';
import 'package:meditation_app/localization.dart';

class SessionPreferencesScreen extends ConsumerStatefulWidget {
  const SessionPreferencesScreen({super.key});

  @override
  ConsumerState<SessionPreferencesScreen> createState() => _SessionPreferencesScreenState();
}

class _SessionPreferencesScreenState extends ConsumerState<SessionPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Localization.of(context)?.translate('start_new_meditation') ?? 'Start New Meditation', ref: ref),
      body: Column(
        children: [
          Expanded(
            child: SessionDurationForm(),
          ),
          const SongSelectionWidget(),
        ],
      ),
      floatingActionButton: LanguageSwitcher(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
