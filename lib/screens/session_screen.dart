import 'package:meditation_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/widgets/timer_widget.dart';


class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionscreenState();
}

class _SessionscreenState extends ConsumerState<SessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {        
        return Scaffold(
          appBar: DefaultAppBar(title: "Meditation", automaticallyImplyLeading: false, ref: ref),
          body: Container(
            child: const Timerwidget(),
          ),
        );
      },
    );
  }
}