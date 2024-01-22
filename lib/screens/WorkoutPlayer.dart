import 'dart:async';

import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class WorkoutPlayer extends StatefulWidget {
  final Workout workout;
  final Function(int) onUpdatePage;

  WorkoutPlayer({required this.workout, required this.onUpdatePage});

  @override
  State<WorkoutPlayer> createState() => _WorkoutPlayerState();
}

class _WorkoutPlayerState extends State<WorkoutPlayer>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  final Stopwatch _activityStopwatch = Stopwatch();
  late int _currentPage;
  late Timer _activityStopwatchTimer;
  String _activityStopwatchResult = '00:00:00';
  bool _activityStopwatchIsRunning = false;

  @override
  void initState() {
    if (widget.workout.pageProgress == widget.workout.activities.length) {
      _currentPage = 0;
    } else {
      _currentPage = widget.workout.pageProgress;
    }
    _pageController = PageController(initialPage: _currentPage);

    super.initState();
  }

  void stopwatchDispose() {
    _activityStopwatchTimer.cancel();
    super.dispose();
  }

  void _toggleActivityStopwatchStartStop() {
    if (_activityStopwatch.isRunning) {
      _activityStopwatchTimer.cancel();
      _activityStopwatch.stop();
    } else {
      _activityStopwatchTimer =
          Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          _activityStopwatchResult =
              '${_activityStopwatch.elapsed.inHours.toString().padLeft(2, '0')}:${_activityStopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_activityStopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
        });
      });
      _activityStopwatch.start();
    }
    setState(() {
      _activityStopwatchIsRunning = !_activityStopwatchIsRunning;
    });
  }

  void _resetActivityStopwatch() {
    _activityStopwatchTimer.cancel();
    _activityStopwatch.reset();
    _activityStopwatch.stop();
    setState(() {
      _activityStopwatchResult = '00:00:00';
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Exit'),
                      content: Text(
                          'Are you sure you want to leave ${widget.workout.workoutName}?'),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, '/Select');
                              await DatabaseService(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .updateWorkoutProgress(
                                      widget.workout.workoutID, _currentPage);
                            },
                            child: const Text('Exit')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text('Cancel'))
                      ],
                    ));
          },
        ),
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: Text(
          widget.workout.workoutName,
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.workout.activities.length + 1,
        //Add one for the finish page
        itemBuilder: (context, index) {
          if (index < widget.workout.activities.length) {
            // Build activity pages
            return buildActivityPage(widget.workout.activities[index]);
          } else {
            // Build the "finish" page
            return buildFinishPage();
          }
        },

        onPageChanged: (int page) {
          setState(() {
            //change the value of the current page to whichever page the user is on
            _currentPage = page;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentPage >
                        0 //only allows previous page if on any other page than the first
                    ? () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves
                                .ease); //to perform and customise the switch between pages
                      }
                    : null,
                child: Text('Previous'),
              ),

              if (_currentPage + 1 <= widget.workout.activities.length)
                Text(
                    'Activity ${_currentPage + 1} of ${widget.workout.activities.length}'),

              // Shows how far through the user is through the workout
              ElevatedButton(
                onPressed: () async {
                  if (_currentPage + 1 < widget.workout.activities.length) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else if (_currentPage + 1 ==
                      widget.workout.activities.length) {
                    // Handle Finish button action
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else {
                    Navigator.pushNamed(context, '/Select');
                    await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateWorkoutProgress(
                            widget.workout.workoutID, _currentPage);
                  }
                },
                child: Text(
                  _currentPage + 1 < widget.workout.activities.length
                      ? 'Next'
                      : _currentPage + 1 == widget.workout.activities.length
                          ? 'Finish'
                          : 'Exit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //widget for each activity built by the PageView
  Widget buildActivityPage(Activity activity) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                activity.activityName,
                style: TextStyle(fontFamily: 'Bebas', fontSize: 70),
              )),
          if (activity.activityType == 'Reps')
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: Column(
                children: [
                  FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Reps: ${activity.reps}',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 50),
                      )),
                  if (activity.weights != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'At weight: ${activity.weights.toString()}',
                          style: TextStyle(fontFamily: 'Bebas', fontSize: 50),
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (activity.activityType == 'Timer')
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: TimerCountdown(
                    format: CountDownTimerFormat.hoursMinutesSeconds,
                    endTime: DateTime.now().add(activity.time),
                    timeTextStyle: TextStyle(fontSize: 50),
                    colonsTextStyle: TextStyle(fontSize: 50),
                    onEnd: () {
                      print('timer finished');
                    },

                  )
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: () {}, child: Icon(Icons.play_arrow_rounded)),
                    ElevatedButton(onPressed: () {}, child: Icon(Icons.replay_rounded))
                  ],
                )
              ],
            ),

          if (activity.activityType == 'Stopwatch')
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _activityStopwatchResult,
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
                              onPressed: _toggleActivityStopwatchStartStop,
                              child: Text(_activityStopwatch.isRunning
                                  ? "Stop"
                                  : "Start")),
                          //Reset button
                          ElevatedButton(
                              onPressed: _resetActivityStopwatch,
                              child: Text('Reset')),
                        ],
                      )
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget buildFinishPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
          ),
          Icon(
            Icons.check_circle_outline_rounded,
            size: 60,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Workout finished!',
            style: TextStyle(fontFamily: 'Bebas', fontSize: 30),
          ),
        ],
      ),
    );
  }
}
