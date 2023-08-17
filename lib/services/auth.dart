import 'package:burnboss/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:burnboss/models/user.dart' as UserModel;

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  UserModel.customUser? _userFromFirebaseUser(User? user)  {
    // ignore: unnecessary_null_comparison
    if (user !=null) {
      return UserModel.customUser(uid: user.uid);
    }else{
      return null;
    }
  }
  //auth change user stream. Every time a user signs in or signs out, we get a response down this stream
  Stream<customUser?> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  //sign in anonymously
  Future signInAnon() async {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}