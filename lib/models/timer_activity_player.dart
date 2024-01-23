import 'dart:async';
import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final Duration initialTime;
  ActivityTimer({Key? key, required this.initialTime}) : super(key: key);

  @override
  ActivityTimerState createState() => ActivityTimerState();
}

class ActivityTimerState extends State<ActivityTimer> {
  late Timer _timer;
  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTime;
    _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
  }

  void _timerCallback(Timer timer) {
    setState(() {
      if (_currentTime.inSeconds > 0) {
        _currentTime -= Duration(seconds: 1);
      } else {
        _timer.cancel();
      }
    });
  }

  void _startTimer() {
    if (!_timer.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
    }
  }

  void _pauseResumeTimer() {
    if(_timer.isActive) {
      setState(() {
        _timer.cancel();
      });
    } else {
      _startTimer();
    }
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _currentTime = widget.initialTime;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${_currentTime.inHours.toString().padLeft(2, '0')}:${(_currentTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_currentTime.inSeconds % 60).toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 50),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _pauseResumeTimer, child: Icon(_timer.isActive ? Icons.pause_rounded : Icons.play_arrow_rounded)),
            SizedBox(width: 30,),
            ElevatedButton(onPressed: _resetTimer, child: Icon(Icons.replay_rounded)),
          ],
        )
      ],
    );
  }
}
