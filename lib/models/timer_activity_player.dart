import 'dart:async';

import 'package:flutter/material.dart';

class ActivityTimer extends StatefulWidget {
  final Duration initialTime;
  ActivityTimer({Key? key, required this.initialTime}) : super(key: key);

  @override
  State<ActivityTimer> createState() => _ActivityTimerState();
}

class _ActivityTimerState extends State<ActivityTimer> {
  late Timer _timer;
  Duration _currentTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _currentTime = widget.initialTime;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentTime.inSeconds > 0) {
          
        }
      });
    })
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
