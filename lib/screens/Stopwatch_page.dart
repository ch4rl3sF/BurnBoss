import 'dart:async';
import 'package:burnboss/screens/NavDrawer.dart';
import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  //initialise an instance of Stopwatch
  final Stopwatch _stopwatch = Stopwatch();

  //Timer
  late Timer _timer;

  //Displayed initial result
  String _result = '00:00:00';
  bool _isRunning = false;

  @override
  //cancels the timer to avoid memory leaks
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  //function to toggle start and stop of the stopwatch
  void _toggleStartStop() {
    if (_stopwatch.isRunning) {
      _timer.cancel();
      _stopwatch.stop();
    } else {
      _timer = Timer.periodic(Duration(milliseconds: 30), (Timer t) {
        //Update the UI
        setState(() {
          _result = '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
        });
      });
      _stopwatch.start();
    }

    setState(() {
      _isRunning = !_isRunning;
    });
  }

  //function will be called when the user presses the Reset button
  void _reset() {
    _timer.cancel();
    _stopwatch.reset();

    //Update the UI
    setState(() {
      _result = '00:00:00';
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch'),
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: Icon(Icons.menu_rounded, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Display the result
            Text(_result, style: TextStyle(fontSize: 50.0),),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Start button
                ElevatedButton(onPressed: _toggleStartStop, child: Text(_stopwatch.isRunning ? "Stop" : "Start")),
                //Reset button
                ElevatedButton(onPressed: _reset, child: Text('Reset')),
              ],
            )
          ],
        ),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}