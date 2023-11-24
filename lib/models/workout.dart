import 'package:burnboss/models/activity.dart';

class Workout {
  late String workoutName;
  late String workoutID;
  final List<Activity> activities;

  // final String activity;

  Workout({required this.workoutName, required this.activities, required this.workoutID});

  Map<String, dynamic> toMap() {
    return {
      'workoutID': workoutID,
      'workoutName': workoutName,
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
