import 'package:flutter/material.dart';

class Activity {
  String activityName;
  int reps;

  Activity({required this.activityName, required this.reps});

  Map<String, dynamic> toMap() {
    return {
      'activityName': activityName,
      'reps': reps,
    };
  }
}