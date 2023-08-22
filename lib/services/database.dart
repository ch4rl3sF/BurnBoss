import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:burnboss/models/workout.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection(
      'users'); //creates the collection, after it is created, it only references it

  Future updateUserData(String name) async {
    return await usersCollection
        .doc(uid)
        .collection('Details')
        .doc('details')
        .set({
      'name': name,
    });
  } //gets a reference to the document and updates it with the user details

  //function to create a workout
  Future createWorkout(String workoutName, String groupName) async {
    final CollectionReference WorkoutsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Workouts');
    final CollectionReference GroupsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Workouts')
        .doc(workoutName)
        .collection('Groups');
    await WorkoutsCollection.doc(workoutName).set({
      'workoutName': workoutName,
    });
    await GroupsCollection.doc(groupName).set({'groupName': groupName, 'groupCreation': DateTime});
  } //gets a reference to the document and updates it with the workout

  //workout list from snapshot
  Iterable<workout> _workoutListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map(
      (doc) {
        return workout(
          workoutName: doc.get('workoutName') ?? '',
          groupName: doc.get('groupName') ?? '',
          // activity: doc.get('activity') ?? ''
        );
      },
    ).toList();
  }

//get users stream
  Stream<Iterable<workout>> get workouts {
    return usersCollection
        .doc(uid)
        .collection('Workouts')
        .snapshots()
        .map(_workoutListFromSnapshot);
  }
}
