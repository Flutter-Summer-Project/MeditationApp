import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/providers/timer_provider.dart';

class AnimatedTimer extends CustomPainter {
  AnimatedTimer({required WidgetRef ref, required int totalTimerDuration}) : _ref = ref,
        _totalTimerDuration = totalTimerDuration;
  var dateTime = DateTime.now();
  final WidgetRef _ref;
  final int _totalTimerDuration;
  late final step = 2 * pi / _totalTimerDuration;

  //60 sec - 360, 1 sec - 6degree
  //12 hours  - 360, 1 hour - 30degrees, 1 min - 0.5degrees

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final seconds = _ref.watch(timerProvider);

    var fillBrush = Paint()
      ..color = Colors.lightBlueAccent;
    canvas.drawArc(Rect.fromCenter(center: center, width: size.width, height: size.height),
        3 * pi / 2 + _totalTimerDuration * step - step * seconds, step * seconds, true, fillBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
