import 'package:burnboss/Home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget depending on if they are signed in
    return Home();
  }
}
