import 'package:burnboss/services/auth.dart';
import 'package:burnboss/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _passwordVisible = true;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
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
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey, //tracks state of form and helps validate it
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          )),
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      obscureText: _passwordVisible,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Sign in'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() => error =
                                'Could not sign in with those credentials');
                            loading = false;
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Register'),
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                        TextButton(
                            child: const Text('Sign in as Guest?'),
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Warning!'),
                                  content: const Text(
                                      'Signing in as a guest means that your workouts will not be transferred!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      child: const Text('Proceed'),
                                      onPressed: () async {
                                        Navigator.pop(context, 'Proceed');
                                        setState(() {
                                          loading = true;
                                        });
                                        dynamic result =
                                            await _auth.signInAnon();
                                        if (result == null) {
                                          error = ('error signing in');
                                          loading = false;
                                        } else {
                                          print('signed in as guest');
                                          print(result.uid);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
