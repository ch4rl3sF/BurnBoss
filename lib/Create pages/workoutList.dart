import 'package:burnboss/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class workoutList extends StatefulWidget {
  const workoutList({Key? key}) : super(key: key);

  @override
  State<workoutList> createState() => _workoutListState();
}

class _workoutListState extends State<workoutList> {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<Iterable<workout>?>(context);
    workouts?.forEach((workout) {
      print(workout.workoutName);
      print(workout.groupName);
      // print(workout.activity);
    });

    return const Placeholder();
  }
}
