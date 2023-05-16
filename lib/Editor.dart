import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'NavDrawer.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor'),
      ),
      body: Container(
        child: Text('Editor'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      drawer: NavDrawerWidget(),
    );
  }
}
