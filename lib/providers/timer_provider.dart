import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/providers/selected_session_provider.dart';

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier({required int timerValue}) : _timerValue = timerValue, super(timerValue);

  int _timerValue;
  get timerValue => _timerValue;
  void setTimerValue(int newValue) {
    _timerValue = newValue;
    state = _timerValue;
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, int>(
        (ref) => TimerNotifier(timerValue: ref.watch(selectedSessionNotifierProvider).getSessionDuration().inSeconds)
);
