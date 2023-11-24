import 'package:burnboss/models/activity.dart';

class Workout {
  late String workoutName;
  final List<Activity> activities;

  // final String activity;

  Workout({required this.workoutName, required this.activities});

  Map<String, dynamic> toMap() {
    return {
      'workoutName': workoutName,
      'activities': activities.map((activity) => activity.toMap()).toList(),
    };
  }
}
