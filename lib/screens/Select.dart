import 'package:flutter/material.dart';
import 'package:burnboss/screens/NavDrawer.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Color(0xff292929),
          toolbarHeight: 125,
          title: const Text(
            'Select',
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
              icon: Icon(Icons.menu_rounded, size: 30),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
          ],
        ),
        drawer: const NavDrawerWidget(),
    );
  }

  Widget buildSelectCard({
    required String title,
    required String muscleGroup,
    // required GestureTapCallback action,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: Colors.white,
      // color: Color(0xff292929),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.grey, width: 2),
      ),
      child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_rounded),
              ],
            ),
          ),
          title: Text(title),
          trailing: Icon(
            Icons.star_rounded,
            color: Colors.amber,
          )),
    );
  }
}
