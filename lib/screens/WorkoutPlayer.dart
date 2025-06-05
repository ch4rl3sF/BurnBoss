import 'package:burnboss/models/workout.dart';
import 'package:burnboss/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/activityPage.dart';

class WorkoutPlayer extends StatefulWidget {
  final Workout workout;
  final Function(int) onUpdatePage;

  const WorkoutPlayer({super.key, required this.workout, required this.onUpdatePage});

  @override
  State<WorkoutPlayer> createState() => _WorkoutPlayerState();
}

class _WorkoutPlayerState extends State<WorkoutPlayer>
    with TickerProviderStateMixin {
  PageController _pageController = PageController();
  late int _currentPage;
  bool _isSetPageViewInteracting = false;

  @override
  void initState() {
    super.initState();
    if (widget.workout.pageProgress == widget.workout.activities.length) {
      _currentPage = 0;
    } else {
      _currentPage = widget.workout.pageProgress;
    }
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
          style: const TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
      ),
      body: IgnorePointer(
        ignoring: _isSetPageViewInteracting,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.workout.activities.length + 1,
          //Add one for the finish page
          itemBuilder: (context, index) {
            if (index < widget.workout.activities.length) {
              return ActivityPage(
                activity: widget.workout.activities[index],
                onSetPageViewInteraction: (isInteracting) {
                  setState(() {
                    _isSetPageViewInteracting = isInteracting;
                  });
                },
              );
            } else {
              return buildFinishPage();
            }
          },
          physics: const ClampingScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              //change the value of the current page to whichever page the user is on
              _currentPage = page;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentPage >
                        0 //only allows previous page if on any other page than the first
                    ? () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves
                                .ease); //to perform and customise the switch between pages
                      }
                    : null,
                child: const Text('Previous'),
              ),

              if (_currentPage + 1 <= widget.workout.activities.length)
                Text(
                    'Activity ${_currentPage + 1} of ${widget.workout.activities.length}'),

              // Shows how far through the user is through the workout
              ElevatedButton(
                onPressed: () async {
                  if (_currentPage + 1 < widget.workout.activities.length) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  } else if (_currentPage + 1 ==
                      widget.workout.activities.length) {
                    // Handle Finish button action
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
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

  Widget buildFinishPage() {
    return const Center(
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


