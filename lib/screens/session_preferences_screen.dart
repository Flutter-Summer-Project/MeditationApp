import 'package:meditation_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/session_duration_form.dart';
import 'package:meditation_app/widgets/song_selection_widget.dart';


class SessionPreferencesScreen extends ConsumerStatefulWidget {
  const SessionPreferencesScreen({super.key});

  @override
  ConsumerState<SessionPreferencesScreen> createState() => _sessionPreferencesScreenState();
}

class _sessionPreferencesScreenState extends ConsumerState<SessionPreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Start New Meditation", automaticallyImplyLeading: true, ref: ref),
      body: Column(
        children: [
          Expanded(
            child: SessionDurationForm(),
          ),
          const SongSelectionWidget(),
        ],
      ),
    );
  }
}