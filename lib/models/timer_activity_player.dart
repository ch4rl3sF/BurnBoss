import 'dart:async';
import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final Duration initialTime;
  const ActivityTimer({super.key, required this.initialTime});

  @override
  ActivityTimerState createState() => ActivityTimerState();
}

class ActivityTimerState extends State<ActivityTimer> {
  late Timer _timer;
  Duration _currentTime = Duration.zero;
  bool _timerIsRunning = false;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTime;
    //Maybe add isActive = false here?
    _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
  }

  void _timerCallback(Timer timer) {
    setState(() {
      if (_currentTime.inSeconds > 0 && _timerIsRunning == true) {
        _currentTime -= const Duration(seconds: 1);
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_timer.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), _timerCallback);
      setState(() {
        _timerIsRunning = true;
      });
    }
  }

  void _pauseResumeTimer() {
    if(_timer.isActive) {
      setState(() {
        _timer.cancel();
        _timerIsRunning = false;
      });
    } else {
      _startTimer();
      _timerIsRunning = true;
    }
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _currentTime = widget.initialTime;
      _timerIsRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${_currentTime.inHours.toString().padLeft(2, '0')}:${(_currentTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 50),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _pauseResumeTimer, child: Icon(_timerIsRunning ? Icons.pause_rounded : Icons.play_arrow_rounded)),
            const SizedBox(width: 30,),
            ElevatedButton(onPressed: _resetTimer, child: const Icon(Icons.replay_rounded)),
          ],
        )
      ],
    );
  }
}
