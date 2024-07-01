import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/session_summary_widget.dart';
import 'package:meditation_app/widgets/language_switcher.dart';
import 'package:meditation_app/localization.dart';


class PostSessionScreen extends ConsumerStatefulWidget {
  const PostSessionScreen({super.key});

  @override
  ConsumerState<PostSessionScreen> createState() => _PostSessionScreenState();
}

class _PostSessionScreenState extends ConsumerState<PostSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Localization.of(context)?.translate('session_summary') ?? 'Session Summary',
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
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SessionSummaryWidget(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(Localization.of(context)?.translate('main_screen') ?? 'Main screen'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: LanguageSwitcher(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}