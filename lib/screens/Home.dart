import 'package:flutter/material.dart';
import 'package:burnboss/screens/NavDrawer.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Color(0xff292929),
        toolbarHeight: 125,
        title: const Text(
          'BurnBoss',
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
            icon: Icon(Icons.menu_rounded, size: 30,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: NavDrawerWidget(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child: Column(
            children: [
              SizedBox(
                height: 315,
                width: 300,
                child: GridView.count(
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  crossAxisCount: 2,
                  primary: false,
                  children: [
                    buildHomeCard(
                        pageIcon: Icons.mouse_outlined,
                        label: 'Select',
                        action: () {
                          Navigator.pushNamed(context,
                              '/Select'); //follow the route given above
                        }),
                    buildHomeCard(
                        pageIcon: Icons.add,
                        label: 'Create',
                        action: () {
                          Navigator.pushNamed(context, '/Creator');
                        }),
                    buildHomeCard(
                        pageIcon: Icons.calendar_month,
                        label: 'Calendar',
                        action: () {
                          Navigator.pushNamed(context, '/Calendar');
                        }),
                    buildHomeCard(
                        pageIcon: Icons.access_alarm,
                        label: 'Stopwatch',
                        action: () {
                          Navigator.pushNamed(context, '/Stopwatch');
                        }),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              buildHomeCard(
                  pageIcon: Icons.accessible_forward,
                  label: 'Go!',
                  action: () {
                    print('Go button pressed');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHomeCard({
    required IconData pageIcon,
    required String label,
    required GestureTapCallback action,
  }) {
    return Card(
      // color: Color(0xff292929),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey, width: 0.5)),
      child: InkWell(
        onTap: action,
        child: SizedBox(
          width: 200,
          height: 125,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  pageIcon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
