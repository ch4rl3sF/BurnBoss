import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class workoutList extends StatefulWidget {
  const workoutList({Key? key}) : super(key: key);

  @override
  State<workoutList> createState() => _workoutListState();
}

class _workoutListState extends State<workoutList> {
  @override
  Widget build(BuildContext context) {
    final workouts = Provider.of<QuerySnapshot?>(context);
    // print(workouts?.docs);
    for (var doc in workouts!.docs) {
      print(doc.data());
    }

    return const Placeholder();
  }
}
