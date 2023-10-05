import 'package:burnboss/Create%20pages/NewWorkout.dart';
import 'package:burnboss/models/activity.dart';
import 'package:flutter/material.dart';

class editActivity extends StatelessWidget {
  editActivity({Key? key, required this.activity}) : super(key: key);
  Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.activityName),
      ),
    );
  }
}
