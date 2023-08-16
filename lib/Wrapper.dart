import 'package:burnboss/Home.dart';
import 'package:burnboss/authenticate/authenticate.dart';
import 'package:burnboss/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<customUser?>(context);
    print(user);
    //return either home or authenticate widget depending on if they are signed in
    if(user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
