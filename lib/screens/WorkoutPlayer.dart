import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/services/database.dart';

class WorkoutPlayer extends StatefulWidget {
  final Workout workout;
  final Function(int) onUpdatePage;

  WorkoutPlayer({required this.workout, required this.onUpdatePage});

  @override
  State<WorkoutPlayer> createState() => _WorkoutPlayerState();
}

class _WorkoutPlayerState extends State<WorkoutPlayer> {
  PageController _pageController = PageController();
  late int _currentPage;

  @override
  void initState() {
    _currentPage = widget.workout.pageProgress;
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
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
                        TextButton(onPressed: () async {
                          Navigator.pushNamed(context, '/Select');
                          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).updateWorkoutProgress(widget.workout.workoutID, _currentPage);
                        }, child: const Text('Exit')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            child: const Text('Cancel'))
                      ],
                    ));
          },
        ),
        title: Text(widget.workout.workoutName),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.workout.activities.length,
        itemBuilder: (context, index) {
          //builds each activity from the list of objects
          return buildActivityPage(widget.workout.activities[index]);
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
              Text(
                  'Activity ${_currentPage + 1} of ${widget.workout.activities.length}'),
              // Shows how far through the user is through the workout
              ElevatedButton(
                onPressed: _currentPage <
                        widget.workout.activities.length -
                            1 //only if not on the last page
                    ? () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }
                    : null,
                child: Text('Next'),
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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  activity.activityName,
                  style: TextStyle(fontFamily: 'Bebas', fontSize: 70),
                )),
          ),
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
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'At weight: ${activity.weights.toString()}',
                        style: TextStyle(fontFamily: 'Bebas', fontSize: 50),
                      ),
                    )
                ],
              ),
            ),
          if (activity.activityType == 'Timer')
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Text('timer')),
          if (activity.activityType == 'Stopwatch')
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Text('stopwatch')),
        ],
      ),
    );
  }
}