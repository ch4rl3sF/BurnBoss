import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:burnboss/models/activity.dart';

class Workout {
  final String workoutName;
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
