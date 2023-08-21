import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users'); //creates the collection, after it is created, it only references it

  Future updateUserData(String name) async {
    return await usersCollection.doc(uid).collection('Details').doc('details').set({
      'name': name,
    });
  } //gets a reference to the document and updates it
}