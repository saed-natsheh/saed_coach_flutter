import 'package:flutter/material.dart';

class SaedApp extends StatelessWidget {
  const SaedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePageScreen());
  }
}

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String pageName = 'Club Manage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.sports_football_outlined, color: Colors.green),
            SizedBox(width: 6),
            Text(pageName),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.people, color: Colors.green),
                      SizedBox(height: 6),
                      Text('7'),
                      SizedBox(height: 6),
                      Text('Team'),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),

                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.calendar_month, color: Colors.green),
                      SizedBox(height: 6),
                      Text('14'),
                      SizedBox(height: 6),
                      Text('Games'),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),

                        blurRadius: 1,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.person, color: Colors.green),
                      SizedBox(height: 6),
                      Text('122'),
                      SizedBox(height: 6),
                      Text('Players'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Next Game',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Sat 15 Jun'),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.security, color: Colors.green, size: 36),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lions fc Vs Eagles'),
                          Text('stadium City'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          pageName = 'Saed';
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('Detieals'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('LineUp'),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Stream'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lineup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('11/11 Confirmed'),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("max carter"), Text("forward")],
                      ),
                      Row(children: [Icon(Icons.done), Text("attending")]),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Ella Woods"), Text("forward")],
                      ),
                      Row(children: [Icon(Icons.question_mark), Text("?")]),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("max carter"), Text("forward")],
                      ),
                      Row(children: [Icon(Icons.cancel), Text("Absent")]),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("club news"), Text("see all")],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.energy_savings_leaf),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("weekly tip : stay hydrated !"),
                      Text("ensuere your child"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
