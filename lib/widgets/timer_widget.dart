import 'package:meditation_app/localization.dart';
import 'package:meditation_app/providers/flag_provider.dart';
import 'package:meditation_app/providers/rating_provider.dart';
import 'package:meditation_app/providers/selected_session_provider.dart';
import 'package:meditation_app/providers/selected_song_provider.dart';
import 'package:meditation_app/providers/session_provider.dart';
import 'package:meditation_app/audio_player.dart';
import 'package:meditation_app/providers/timer_provider.dart';
import 'package:meditation_app/session.dart';
import 'package:meditation_app/widgets/rating_widget.dart';
import 'package:meditation_app/widgets/heartbeat_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:meditation_app/boxes.dart';
import 'package:meditation_app/widgets/animated_timer.dart';

class Timerwidget extends ConsumerStatefulWidget {
  const Timerwidget({super.key});

  @override
  ConsumerState<Timerwidget> createState() => _TimerwidgetState();
}

class _TimerwidgetState extends ConsumerState<Timerwidget> {
  late Duration sessionDuration;
  late Duration phaseDuration;
  bool sessionDurationInitialized = false;
  Timer? timer;
  final AudioPlayerManager audioPlayerManager = AudioPlayerManager();

  Future<void> initializeAudioPlayer() async {
    if (mounted) {
      setState(() {});
    }
  }

  void startTimer() {
    String _breathingStatus = Localization.of(context)?.translate('breathe_in') ?? 'Breathe in';
    final Session session = ref.watch(selectedSessionNotifierProvider);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (sessionDuration.inSeconds <= 0) {
          endSession();
          return;
        }

        if (phaseDuration.inSeconds <= 0) {
          phaseDuration = session.getPhaseDuration();
        }

        int dif =
            session.getSessionDuration().inSeconds - sessionDuration.inSeconds;
        int periodDuration = session.getPhaseDuration().inSeconds;
        if (dif % periodDuration == 0) {
          if (dif % (2 * periodDuration) == 0) {
            _breathingStatus =
                Localization.of(context)?.translate('breathe_in') ??
                    'Breathe in';
          } else {
            _breathingStatus =
                Localization.of(context)?.translate('breathe_out') ??
                    'Breathe out';
          }
        }

        ref.watch(flagNotifierProvider.notifier).setFlag(true);

        sessionDuration -= const Duration(seconds: 1);
        phaseDuration -= const Duration(seconds: 1);
        ref.watch(timerProvider.notifier).setTimerValue(sessionDuration.inSeconds);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String _breathingStatus = Localization.of(context)?.translate('breathe_in') ?? 'Breathe in';
    final Session session = ref.watch(selectedSessionNotifierProvider);

    if (!sessionDurationInitialized) {
      sessionDuration = session.getSessionDuration();
      phaseDuration = session.getPhaseDuration();
      sessionDurationInitialized = true;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              Localization.of(context)?.translate('session_timer') ??
                  'Session Timer',
              style: TextStyle(fontSize: 20),
            ),
            mainTimerDisplay(),
            const SizedBox(height: 16),
            Text(
              _breathingStatus,
              style: const TextStyle(fontSize: 20),
            ),
            phaseTimerDisplay(),
            const SizedBox(height: 16),
            HeartbeatAnimation(),
            const SizedBox(height: 16),
            startTimerButton(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget startTimerButton() {
    final bool timerIsRunning = timer != null && timer!.isActive;
    final bool timerIsCompleted = sessionDuration.inSeconds <= 0;

    return timerIsRunning || !timerIsCompleted && timer != null
        ? Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (timerIsRunning) {
                      setState(() => timer?.cancel());
                      audioPlayerManager.stopAudio();
                      ref.watch(flagNotifierProvider.notifier).setFlag(false);
                    } else {
                      startTimer();
                      audioPlayerManager.resumeAudio();
                      ref.watch(flagNotifierProvider.notifier).setFlag(true);
                    }
                  },
                  child: timerIsRunning
                      ? Text(Localization.of(context)?.translate('pause') ??
                          'Pause')
                      : Text(Localization.of(context)?.translate('resume') ??
                          'Resume'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    endSession();
                  },
                  child: Text(
                      Localization.of(context)?.translate('end_session') ??
                          'End session'),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: () => {playAudio(), startTimer()},
              child: Text(Localization.of(context)?.translate('start_timer') ??
                  'Start timer'),
            ),
          );
  }

  void playAudio() {
    final selectedSongPath = ref.watch(selectedSongProvider);
    audioPlayerManager.playAudio(selectedSongPath);
  }

  void endSession() async {
  setState(() => timer?.cancel()); 
  audioPlayerManager.stopAudio();
  audioPlayerManager.dispose();
  ref.watch(flagNotifierProvider.notifier).setFlag(false);
  ref.watch(timerProvider.notifier).setTimerValue(0);
  await showDialog(context: context, builder: (BuildContext context) {
    return RatingDialog();
  });

    addFinishedSession();
    Navigator.pushNamed(context, '/');
  }

  void addFinishedSession() {
    final finishedSessions =
    ref.watch(finishedSessionNotifierProvider.notifier);
    final session = ref.watch(selectedSessionNotifierProvider);
    final rating = ref.watch(ratingNotifierProvider);

    Session finishedSession = Session.sessionAndPeriodDurationInit(
        session.getSessionDuration() - sessionDuration,
        session.getPeriodDuration());
    finishedSessions.addSession(finishedSession);

    String newSession =
        Localization.of(context)?.translate('new_session') ?? 'New session';
    String sessionTime =
        Localization.of(context)?.translate('session_time') ?? 'Session time';
    String taskCompRate =
        Localization.of(context)?.translate('task_comp_rate') ??
            'Task completion rate';
    String sessionRating =
        Localization.of(context)?.translate('rating') ?? 'Rating';
    String noRating =
        Localization.of(context)?.translate('no_rating') ?? 'No rating';

// Then, format the string
    String textToAdd =
        '$newSession: ${DateFormat('dd/MM/yyyy HH:mm').format(
        DateTime.now())}\n'
        '$sessionTime: ${Session.formattedDuration(
        finishedSession.getSessionDuration())}\n'
        '$taskCompRate: ${((finishedSession
        .getSessionDuration()
        .inSeconds / session
        .getSessionDuration()
        .inSeconds) * 100).toStringAsFixed(0)}%\n'
        '$sessionRating: ${rating == '' ? noRating : '$rating/5'}';

    sessionsBox.add(
        textToAdd
    );
  }

  Widget mainTimerDisplay() {
    final Session session = ref.watch(selectedSessionNotifierProvider);
    return SizedBox(
      width: 150,
      height: 150,

      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(painter: AnimatedTimer(
                ref: ref,
                totalTimerDuration: session.getSessionDuration().inSeconds
            ))
          ),
          Center(
            child: Text(
            '${sessionDuration.inMinutes.toString().padLeft(2, '0')}:${(sessionDuration.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.0,
              ),
            ),
          ),
          Center(
            child: Text(
              '${sessionDuration.inMinutes.toString().padLeft(2, '0')}:${(sessionDuration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                ),
              ),
            )
          ],
        ),
      );
    }

  Widget phaseTimerDisplay() {
      final Session session = ref.watch(selectedSessionNotifierProvider);

      return SizedBox(
        width: 130,
        height: 130,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 -
                  phaseDuration.inSeconds /
                      session.getPhaseDuration().inSeconds,
              valueColor: AlwaysStoppedAnimation(Colors.green[300]),
              backgroundColor: Colors.white,
            ),
            Center(
              child: Text(
                '${phaseDuration.inMinutes.toString().padLeft(2, '0')}:${(phaseDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                ),
              ),
            )
          ],
        ),
      );
    }
}
