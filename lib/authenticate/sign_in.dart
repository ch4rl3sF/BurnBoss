import 'package:burnboss/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 55,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Bebas',
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            icon: Icon(
              Icons.menu_rounded,
              size: 30,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: ElevatedButton(
            child: Text('Sign in Anon'),
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if (result == null){
                print('error signing in');
              } else {
                print('signed in');
                print(result.uid);
              }
            },
          )),
    );
  }
}
