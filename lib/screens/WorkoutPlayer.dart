import 'package:burnboss/models/activity.dart';
import 'package:burnboss/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutPlayer extends StatefulWidget {
  final Workout workout;

  WorkoutPlayer({required this.workout});

  @override
  State<WorkoutPlayer> createState() => _WorkoutPlayerState();
}

class _WorkoutPlayerState extends State<WorkoutPlayer> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.workoutName),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.workout.activities.length,
        itemBuilder: (context, index) {
          return buildActivityPage(widget.workout.activities[index]);
        },
        onPageChanged: (int page) {
          setState(() {
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
                onPressed: _currentPage > 0
                    ? () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }
                    : null,
                child: Text('Previous'),
              ),
              Text(
                  'Activity ${_currentPage + 1} of ${widget.workout.activities.length}'),
              ElevatedButton(
                onPressed: _currentPage < widget.workout.activities.length - 1
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

  Widget buildActivityPage(Activity activity) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Activity: ${activity.activityName}'),
        ],
      ),
    );
  }
}
