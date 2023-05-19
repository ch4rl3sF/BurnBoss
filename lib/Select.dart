import 'package:flutter/material.dart';
import 'NavDrawer.dart';


class SelectPage extends StatelessWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select'),
      ),
      body: Container(
        child: Text('Select'),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}