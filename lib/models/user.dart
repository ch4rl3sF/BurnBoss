class CustomUser {
  final String? uid;
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

  void updateEmail(String newEmail) {
    email = newEmail;
  }

  void updateUsername(String newUsername) {
    username = newUsername;
  }

}
