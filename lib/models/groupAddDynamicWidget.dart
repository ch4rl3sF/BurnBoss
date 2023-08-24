import 'package:flutter/material.dart';

class groupAddDynamicWidget extends StatelessWidget {
  const groupAddDynamicWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController groupAdd = TextEditingController();
    return Container(
      width: 200,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: new TextFormField(
        controller: groupAdd,
        decoration: const InputDecoration(
          labelText: 'Group Name',
          border: OutlineInputBorder(),
        ),
      ),
    );;
  }
}
