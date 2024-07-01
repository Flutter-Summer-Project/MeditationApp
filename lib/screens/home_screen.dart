import 'package:meditation_app/widgets/default_app_bar.dart';
import 'package:meditation_app/widgets/session_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/language_switcher.dart';
import 'package:meditation_app/localization.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: Localization.of(context)?.translate('app_title') ?? 'Meditation Helper', automaticallyImplyLeading: false, ref: ref),
      body: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SessionListWidget(),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/session_preferences');
              },
              child: Text(Localization.of(context)?.translate('start_new_session') ?? 'Start new session'),
            ),
          ],
        ),
      ),
      floatingActionButton: LanguageSwitcher(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}


