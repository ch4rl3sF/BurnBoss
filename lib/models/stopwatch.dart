import 'dart:async';

import 'package:flutter/material.dart';
class ActivityStopwatch extends StatefulWidget {
  // Create a static instance of the class
  static final ActivityStopwatch _instance = ActivityStopwatch._internal();

  // Provide a factory constructor to return the instance
  factory ActivityStopwatch({Key? key}) {
    return _instance;
  }

  ActivityStopwatch._internal({Key? key}) : super(key: key);

  @override
  State<ActivityStopwatch> createState() => ActivityStopwatchState();
}

class ActivityStopwatchState extends State<ActivityStopwatch> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _stopwatchTimer;
  String _stopwatchResult = '00:00:00';
  bool _stopwatchIsRunning = false;


  @override
  void initState() {
    super.initState();
    print('new stopwatch made');
  }

  void stopwatchDispose() {
    _stopwatchTimer.cancel();
    super.dispose();
    print('stopwatch disposed');
  }

  void _toggleStopwatchStartStop() {
    if (mounted) {
      if (_stopwatch.isRunning) {
        _stopwatchTimer.cancel();
        _stopwatch.stop();
      } else {
        _stopwatchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (mounted) {
            setState(() {
              _stopwatchResult =
              '${_stopwatch.elapsed.inHours.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
            });
          } else {
            _stopwatchTimer.cancel(); // Cancel the timer if the widget is no longer mounted
          }
        });
        _stopwatch.start();
      }
      setState(() {
        _stopwatchIsRunning = !_stopwatchIsRunning;
      });
    }
  }

  void _resetStopwatch() {
    if (mounted) {
      _stopwatchTimer.cancel();
      _stopwatch.reset();
      _stopwatch.stop();
      setState(() {
        _stopwatchResult = '00:00:00';
      });
    }
  }

  Widget build(BuildContext context) {
    return
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _stopwatchResult,
                    style: TextStyle(fontSize: 50.0),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Start button
                      ElevatedButton(
                          onPressed: _toggleStopwatchStartStop,
                          child: Text(_stopwatch.isRunning
                              ? "Stop"
                              : "Start")),
                      //Reset button
                      ElevatedButton(
                          onPressed: _resetStopwatch,
                          child: Text('Reset')),
                    ],
                  )
                ],
              ),
            );
  }
}
