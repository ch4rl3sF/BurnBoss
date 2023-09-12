import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burnboss/models/workout.dart';

import 'package:burnboss/models/activity.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //creates the collection, after it is created, it only references it
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection(
      'users');

  //gets a reference to the document and updates it with the user details
  Future updateUserData(String name) async {
    return await usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .set({
      'name': name,
    });
  }

  //function to create a workout
  Future createWorkout(Workout workout) async {
    // Reference to the Firestore collection where workouts are stored
    final CollectionReference WorkoutsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Workouts');

    // Convert the Workout object to a map
    Map<String, dynamic> workoutData = workout.toMap();

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
}
