import 'package:meditation_app/providers/flag_provider.dart';
import 'package:meditation_app/providers/rating_provider.dart';
import 'package:meditation_app/providers/selected_session_provider.dart';
import 'package:meditation_app/providers/selected_song_provider.dart';
import 'package:meditation_app/providers/session_provider.dart';
import 'package:meditation_app/audio_player.dart';
import 'package:meditation_app/session.dart';
import 'package:meditation_app/widgets/rating_widget.dart';
import 'package:meditation_app/widgets/heartbeat_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:meditation_app/boxes.dart';


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
  String _breathingStatus = 'Breathe in';

  Future<void> initializeAudioPlayer() async {
    await audioPlayerManager.init();
    if (mounted) {
      setState(() {});
    }
  }

  void startTimer() {
    final Session session = ref.watch(selectedSessionNotifierProvider);

    timer = Timer.periodic(const Duration(seconds: 1), (_){
      setState(() {
        if (sessionDuration.inSeconds <= 0) {
          endSession(); 
          return;
        }

        if (phaseDuration.inSeconds <= 0) {
          phaseDuration = session.getPhaseDuration();
        }
        
        int dif = session.getSessionDuration().inSeconds - sessionDuration.inSeconds;
        int periodDuration = session.getPhaseDuration().inSeconds;
        if (dif % periodDuration == 0) {
          if (dif % (2 * periodDuration) == 0) {
            _breathingStatus = 'Breathe in';
          } else {
            _breathingStatus = 'Breathe out';
          }
        }

        ref.watch(flagNotifierProvider.notifier).setFlag(true);

        sessionDuration -= const Duration(seconds: 1);
        phaseDuration -= const Duration(seconds: 1);
      });
    }
    );
  }
  

  @override
  Widget build(BuildContext context) {
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
            const Text("Session Timer", style: TextStyle(fontSize: 20),),
            mainTimerDisplay(),
            const SizedBox(height: 16),
            Text(_breathingStatus, style: const TextStyle(fontSize: 20),),
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

    return timerIsRunning || !timerIsCompleted && timer != null ?
      Padding(
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
              child: timerIsRunning ? const Text('Pause') : const Text('Resume'),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () {
                endSession();
              },
             child: const Text('End session'),
            )
        ],
        ),
      ) 
      :
     Padding(
       padding: const EdgeInsets.all(24.0),
       child: ElevatedButton(
        onPressed: () => {playAudio(), startTimer()},
         child: const Text('Start timer'),
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

  await showDialog(context: context, builder: (BuildContext context) {
    return RatingDialog();
  });

  addFinishedSession();
  Navigator.pushNamed(context, '/post_session');
}

void addFinishedSession() {
  final finishedSessions = ref.watch(finishedSessionNotifierProvider.notifier);
  final session = ref.watch(selectedSessionNotifierProvider);
  final rating = ref.watch(ratingNotifierProvider);

  Session finishedSession = Session.sessionAndPeriodDurationInit(session.getSessionDuration() - sessionDuration, session.getPeriodDuration());
  finishedSessions.addSession(finishedSession);
  
  sessionsBox.add(
      'Time: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}\n'
      'Session time: ${Session.formattedDuration(finishedSession.getSessionDuration())}\n'
      'Task completion rate: ${(
        (finishedSession.getSessionDuration().inSeconds / session.getSessionDuration().inSeconds) * 100
        ).toStringAsFixed(0)}%\n'
      'Rating: ${rating == '' ? 'No rating' : '$rating/5'}'
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
          CircularProgressIndicator(
            value: 1 - sessionDuration.inSeconds / session.getSessionDuration().inSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.green[500]),
            backgroundColor: Colors.white,
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
            value: 1 - phaseDuration.inSeconds / session.getPhaseDuration().inSeconds,
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