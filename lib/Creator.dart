import 'package:flutter/material.dart';
import 'NavDrawer.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creator'),
      ),
      body: Container(
        child: Text('Creator'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}
