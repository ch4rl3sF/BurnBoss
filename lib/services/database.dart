import 'dart:async';
import 'dart:typed_data';

import 'package:burnboss/models/user.dart';
import 'package:burnboss/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burnboss/models/workout.dart';
import 'package:burnboss/models/activity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> saveProfilePic({
    required Uint8List file,
  }) async {
    String resp = 'Some error occurred';
    try {
      String imageURL = await uploadImageToStorage('ProfileImage', file);
      await usersCollection
          .doc(uid)
          .collection('ProfilePic')
          .add({'imageLink': imageURL});
      resp = 'Success saving image';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<Uint8List?> getProfilePic() async {
    try {
      QuerySnapshot snapshot = await usersCollection
          .doc(uid)
          .collection('ProfilePic')
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String imageURL = snapshot.docs.first.get('imageLink');
        http.Response response = await http.get(Uri.parse(imageURL));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future updateUserData(CustomUser customUser) async {
    DocumentReference userDocument =
        await usersCollection.doc(uid).collection('Details').doc('details');

    Map<String, dynamic> userData = customUser.toMap();

    await userDocument.set(userData);
  }

  Future updateUserEmail(String newEmail) async {
    await AuthService().updateEmail(newEmail);
    usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .update({'email': newEmail}).then((value) => print("Email updated!"),
            onError: (e) => print('Email not updated, error: $e'));
  }

  Future updateUsername(String newUsername) async {
    return usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .update({'username': newUsername}).then(
            (value) => print("Username updated!"),
            onError: (e) => print('Username not updated, error: $e'));
  }

  Future<CustomUser?> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .get();

    if (snapshot.exists) {
      CustomUser customUser = CustomUser.fromMap(snapshot.data());
      return customUser;
    } else {
      return null;
    }
  }

  Future? updateTheme(bool isLightTheme) async {
    return await usersCollection
        .doc(uid)
        .collection('Theme')
        .doc('theme')
        .set({'isLightTheme': isLightTheme});
  }

  Future<bool?> getTheme() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await usersCollection.doc(uid).collection('Theme').doc('theme').get();

    if (snapshot.exists) {
      return snapshot.data()?['isLightTheme'];
    } else {
      return null; // Return null if the document doesn't exist
    }
  }

  //function to create a workout
  Future createWorkout(Workout workout) async {
    // Add the workout to Firestore
    DocumentReference workoutDocument = await WorkoutsCollection.doc();

    // Set the workout data, including the workout name
    Map<String, dynamic> workoutData = {
      'workoutID': workoutDocument.id,
      'workoutName': workout.workoutName,
      'pageProgress': workout.pageProgress,
    };

    await workoutDocument.set(workoutData);

    // For each activity in the workout, create a subCollection within the workout document
    for (int i = 0; i < workout.activities.length; i++) {
      CollectionReference activitiesCollection =
          workoutDocument.collection('activities');
      Activity activity = workout.activities[i];
      // Use the position in the list as the ordering criteria

      DocumentReference activityDocument = await activitiesCollection.doc();

      Map<String, dynamic> activityData = {
        'activityID': activityDocument.id,
        'activityName': activity.activityName,
        'reps': activity.reps,
        'sets': activity.sets,
        'rest': activity.rest.inMilliseconds,
        'weights': activity.weights,
        'time': activity.time.inMilliseconds,
        'activityType': activity.activityType,
        // Convert Duration to milliseconds
        'stopwatchUsed': activity.stopwatchUsed,
        'position': i,
      };
      await activityDocument.set(activityData);
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
          pageProgress: workoutDocSnapshot.get('pageProgress'),
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

  //function to update the current workout progress
  Future updateWorkoutProgress(String workoutID, int newPageProgress) async {
    return WorkoutsCollection.doc(workoutID)
        .update({'pageProgress': newPageProgress}).then(
            (value) => print(
                'DocumentSnapshot successfully updated with new page progress'),
            onError: (e) => print('Error updating document $e'));
  }

  Future editActivities(Workout workout, List activityIDsDeleted) async {
    for (var activityID in activityIDsDeleted) {
      // Use the activity ID when deleting documents
      WorkoutsCollection.doc(workout.workoutID)
          .collection('activities')
          .doc(activityID)
          .delete();
    }

    if (workout.activities.isNotEmpty) {
      for (int i = 0; i < workout.activities.length; i++) {
        CollectionReference activitiesCollection =
            WorkoutsCollection.doc(workout.workoutID).collection('activities');
        Activity activity = workout.activities[i];

        if (activity.activityID.isNotEmpty) {
          // Use the activity ID when updating documents
          DocumentReference activityDocument =
              activitiesCollection.doc(activity.activityID);

          Map<String, dynamic> activityData = {
            'activityID': activityDocument.id,
            'activityName': activity.activityName,
            'reps': activity.reps,
            'sets': activity.sets,
            'rest': activity.rest.inMilliseconds,
            'weights': activity.weights,
            'time': activity.time.inMilliseconds,
            'activityType': activity.activityType,
            'stopwatchUsed': activity.stopwatchUsed,
            'position': i,
          };
          await activityDocument.set(activityData);
        } else {
          // Use the activity ID when updating documents
          DocumentReference activityDocument = activitiesCollection.doc();

          Map<String, dynamic> activityData = {
            'activityID': activityDocument.id,
            'activityName': activity.activityName,
            'reps': activity.reps,
            'sets': activity.sets,
            'rest': activity.rest.inMilliseconds,
            'weights': activity.weights,
            'time': activity.time.inMilliseconds,
            'activityType': activity.activityType,
            'stopwatchUsed': activity.stopwatchUsed,
            'position': i,
          };
          await activityDocument.set(activityData);
        }
      }
    } else {
      print('No activities to be deleted');
    }
  }
}
