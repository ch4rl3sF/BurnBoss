import 'package:burnboss/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/models/activity.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;

  // Reference to the Firestore collection where workouts are stored
  late final CollectionReference WorkoutsCollection;

  DatabaseService({required this.uid}) {
    // Initialize WorkoutsCollection in the constructor
    WorkoutsCollection = FirebaseFirestore.instance.collection('users').doc(uid).collection('Workouts');
  }

  //creates the collection, after it is created, it only references it
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection(
      'users');


  //gets a reference to the document and updates it with the user details
  Future updateUserData(String email) async {
    return await usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .set({
      'email': email,
    });
  }



  //function to create a workout
  Future createWorkout(Workout workout) async {

    // Add the workout to Firestore
    DocumentReference workoutDocument =
        await WorkoutsCollection.doc(workout.workoutName);

    // For each activity in the workout, create a subcollection within the workout document
    for (int i = 0; i < workout.activities.length; i++) {
      CollectionReference activitiesCollection =
          workoutDocument.collection('activities');
      Activity activity = workout.activities[i];
      Map<String, dynamic> activityData = activity.toMap();
      await activitiesCollection.doc(activity.activityName).set(activityData);
    }
  }


  Future getWorkout() async {
    StreamBuilder<QuerySnapshot>(
      stream: WorkoutsCollection.snapshots(),
      builder: (context,snapshot) {
        List<Row> workoutWidgets = [];
        if (snapshot.hasData) {
          final workouts = snapshot.data?.docs.reversed.toList();
          for(var workout in workouts!) {
            final workoutWidget = Row(
              children: [
                Text(workout['Workout name']),
              ],
            );
            workoutWidgets.add(workoutWidget);
          }
        }

        return Expanded(
          child: ListView(
            children: workoutWidgets,
          ),
        );
      },
    );
  }
  // Stream<QuerySnapshot> get workouts {
  //   return WorkoutsCollection.snapshots();
  // }

}
