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
    WorkoutsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Workouts');
  }

  //creates the collection, after it is created, it only references it
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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

    // Set the workout data, including the workout name
    Map<String, dynamic> workoutData = {
      'workoutName': workout.workoutName,
    };

    await workoutDocument.set(workoutData);

    // For each activity in the workout, create a subcollection within the workout document
    for (int i = 0; i < workout.activities.length; i++) {
      CollectionReference activitiesCollection =
          workoutDocument.collection('activities');
      Activity activity = workout.activities[i];
      Map<String, dynamic> activityData = activity.toMap();
      await activitiesCollection.doc(activity.activityName).set(activityData);
    }
  }

  // //function to get all workouts with documents and their fields
  // Future getAllWorkouts() async {
  //
  //   // returns the workouts and their fields
  //   return WorkoutsCollection.get().then((workoutsSnapshot) {
  //     print('Fetching workouts for UID: $uid');
  //     print('Successfully completed');
  //
  //     //for each workout, take the name of the workout and use that in the path to get activities
  //     for (var workoutDocSnapshot in workoutsSnapshot.docs) {
  //       WorkoutsCollection.doc(workoutDocSnapshot.id)
  //           .collection('activities')
  //           .get()
  //           .then((activitiesSnapshot) {
  //         print('Fetching activities for workout: ${workoutDocSnapshot.id}');
  //
  //         //print the data for each activity
  //         for (var activityDocSnapshot in activitiesSnapshot.docs) {
  //           print('${activityDocSnapshot.id} => ${activityDocSnapshot.data()}');
  //         }
  //       });
  //     }
  //     print('documents recieved: ${workoutsSnapshot.docs.length}');
  //   });
  // }

  Future<List<Workout>> getAllWorkouts() async {
    List<Workout> workouts = [];

    try {
      //get a workoutsSnapshot from the collection "Workouts"
      print('Fetching workouts for UID: $uid');
      QuerySnapshot workoutsSnapshot = await WorkoutsCollection.get();
      print('Successfully completed');

      //for each document within the "Workouts collection"
      for (var workoutDocSnapshot in workoutsSnapshot.docs) {
        List<Activity> activities = [];

        // Fetch activities for each workout
        QuerySnapshot activitiesSnapshot =
        await WorkoutsCollection.doc(workoutDocSnapshot.id)
            .collection('activities')
            .get();

        for (var activityDocSnapshot in activitiesSnapshot.docs) {
          // Parse activity data and add to activities list
          Map<String, dynamic>? activityData = activityDocSnapshot.data() as Map<String, dynamic>?;
          if (activityData != null) {
            Activity activity = Activity.fromMap(activityData);
            activities.add(activity);
          }
        }

        // Create a workout object with the fetched data
        Workout workout = Workout(
          workoutName: workoutDocSnapshot.id,
          activities: activities,
        );

        workouts.add(workout);
      }
    } catch (e) {
      print('Error getting workouts: $e');
    }

    return workouts;
  }
}
