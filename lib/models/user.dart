import '../services/database.dart';

class CustomUser {
  final String uid;
  String? email;
  String? username;

  CustomUser({
    required this.uid,
    this.email,
    this.username = 'New User',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }

  factory CustomUser.fromMap(Map<String, dynamic>? map) {
    return CustomUser(
      uid: map?['uid'],
      email: map?['email'],
      username: map?['username'] ?? 'New User',
    );
  }

  // Method to update the email in the database
  Future<void> updateEmail(String newEmail) async {
    email = newEmail;
    // Update email in the database
    await DatabaseService(uid: uid!).updateUserEmail(newEmail);
  }


  // Method to update the email in the database
  Future<void> updateUsername(String newUsername) async {
    print('username is $newUsername');
    // Update email in the database
    await DatabaseService(uid: uid!).updateUsername(newUsername);
  }

}
