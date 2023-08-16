import 'package:flutter/material.dart';
import 'package:burnboss/services/auth.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'Sign up to BurnBoss',
          style: TextStyle(
            fontSize: 35,
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
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TextFormField(
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  print(email);
                  print(password);
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('Sign in'),
                onPressed: () {
                  widget.toggleView();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
