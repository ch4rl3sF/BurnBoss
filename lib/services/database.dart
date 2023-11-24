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
    DocumentReference workoutDocument = await WorkoutsCollection.doc();

    // Set the workout data, including the workout name
    Map<String, dynamic> workoutData = {
      'workoutID': workoutDocument.id,
      'workoutName': workout.workoutName,
    };

    await workoutDocument.set(workoutData);

    // For each activity in the workout, create a subcollection within the workout document
    for (int i = 0; i < workout.activities.length; i++) {
      CollectionReference activitiesCollection =
          workoutDocument.collection('activities');
      Activity activity = workout.activities[i];
      // Use the position in the list as the ordering criteria
      Map<String, dynamic> activityData = {...activity.toMap(), 'position': i};
      await activitiesCollection.doc(activity.activityName).set(activityData);
    }
  }

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
        String workoutName = workoutDocSnapshot.get('workoutName');

        // Fetch activities for each workout
        QuerySnapshot activitiesSnapshot =
            await WorkoutsCollection.doc(workoutDocSnapshot.id)
                .collection('activities')
                .orderBy('position')
                .get();

        for (var activityDocSnapshot in activitiesSnapshot.docs) {
          // Parse activity data and add to activities list
          Map<String, dynamic>? activityData =
              activityDocSnapshot.data() as Map<String, dynamic>?;
          if (activityData != null) {
            Activity activity = Activity.fromMap(activityData);
            activities.add(activity);
          }
        }

        // Create a workout object with the fetched data
        Workout workout = Workout(
          workoutID: workoutDocSnapshot.id,
          workoutName: workoutName,
          activities: activities,
        );

        workouts.add(workout);
      }
    } catch (e) {
      print('Error getting workouts: $e');
    }

    return workouts;
  }

  //Function to delete a workout
  Future deleteWorkout(String workoutID) async {
    return WorkoutsCollection.doc(workoutID).delete().then((doc) async {
      QuerySnapshot activitySnapshot = await WorkoutsCollection.doc(workoutID)
          .collection('activities')
          .get();
      for (var activitySnapshot in activitySnapshot.docs) {
        WorkoutsCollection.doc(workoutID)
            .collection('activities')
            .doc(activitySnapshot.id)
            .delete();
        print('workout deleted: $workoutID');
      }
    }, onError: (e) => print('Couldnt delete workout: $workoutID'));
  }

  //function to edit workout name
  Future editWorkoutName(String workoutID, String workoutName) async {
    return WorkoutsCollection.doc(workoutID)
        .update({'workoutName': workoutName}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
  }

  Future editActivities(Workout workout, List activityNamesDeleted) async {
    if (workout.activities.isNotEmpty) {
      for (int i = 0; i < workout.activities.length; i++) {
        CollectionReference activitiesCollection =
            WorkoutsCollection.doc(workout.workoutID).collection('activities');
        Activity activity = workout.activities[i];
        // Use the position in the list as the ordering criteria
        Map<String, dynamic> activityData = {
          ...activity.toMap(),
          'position': i
        };
        await activitiesCollection.doc(activity.activityName).set(activityData);
      }
    } else {
      print('No activities to be deleted');
    }

    for (var activity in activityNamesDeleted) {
      WorkoutsCollection.doc(workout.workoutID)
          .collection('activities')
          .doc(activity)
          .delete();
    }
  }
}
