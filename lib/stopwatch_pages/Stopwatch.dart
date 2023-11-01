import 'dart:async';

class StopwatchFunction {
  //initialise an instance of Stopwatch
  final Stopwatch _stopwatch = Stopwatch();

  //Timer
  late Timer _timer;

  //Displayed initial result
  String _result = '00:00:00';

  //function will be called when the user presses the Start button
  void _start() {
    //Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(Duration(milliseconds: 30), (Timer t) {
      //Update the UI
      _result =
          '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
    });
    _stopwatch.start();
  }

  //function will be called when the user presses the Pause button
  void _pause() {
    _timer.cancel();
    _stopwatch.stop();
  }

  //function will be called when the user presses the Reset button
  void _reset() {
    _pause();
    _stopwatch.reset();

    //Update the UI
    _result = '00:00:00';
  }
}
