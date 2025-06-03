import 'package:flutter/material.dart';

class GameDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Details'),
        centerTitle: true,
        actions: [Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            _gameCard(),
            SizedBox(height: 12),
            _venueCard(),
            SizedBox(height: 12),
            _startingLineupCard(),
            SizedBox(height: 12),
            _playerAttendanceCard(),
            SizedBox(height: 12),
            _actionButtons(),
            SizedBox(height: 12),
            _coachNotesCard(),
          ],
        ),
      ),
    );
  }

  Widget _gameCard() {
    return Card(
      color: Color(0xff3055a3).withValues(alpha: 0.4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lions FC vs Eagles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Championship League',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Date', style: TextStyle(color: Colors.white)),
                    Text(
                      'Sat, Jun 15',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Time', style: TextStyle(color: Colors.white)),
                    Text(
                      '14:30',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    "UPCOMING",
                    style: TextStyle(color: Color(0xff3055a3)),
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _venueCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.location_on, color: Color(0xff3055a3)),
        title: Text('City Arena Stadium'),
        subtitle: Text('123 Sports Avenue, Downtown'),
        trailing: Text(
          'Get Directions',
          style: TextStyle(color: Color(0xff3055a3)),
        ),
      ),
    );
  }

  Widget _startingLineupCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Starting Lineup',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  '11/11 Confirmed',
                  style: TextStyle(color: Color(0xff3055a3)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              children: [
                Text('Formation: 4-3-3'),
                SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _playerCircle("8", "Carter"),
                    _playerCircle("11", "Johnson"),
                    _playerCircle("7", "Davis"),
                    _playerCircle("3", "Woods"),
                    _playerCircle("6", "Smith"),
                    _playerCircle("10", "Brown"),
                    _playerCircle("3", "Wilson"),
                    _playerCircle("5", "Taylor"),
                    _playerCircle("6", "Miller"),
                    _playerCircle("2", "Garcia"),
                    _playerCircle("1", "Lee", isKeeper: true),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerCircle(String number, String name, {bool isKeeper = false}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: isKeeper ? Color(0xfff1e60e) : Color(0xff3055a3),
          child: Text(number, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 4),
        Text(name, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _playerAttendanceCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Player Attendance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _attendanceRow(
              "Max Carter",
              "Forward • #9",
              Color(0xff3055a3),
              "Confirmed",
            ),
            _attendanceRow(
              "Ella Woods",
              "Midfielder • #8",
              Color(0xfff1e60e),
              "Pending",
            ),
            _attendanceRow(
              "Sandra Lee",
              "Goalkeeper • #1",
              Colors.redAccent,
              "Unavailable",
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: Text("Update Attendance")),
          ],
        ),
      ),
    );
  }

  Widget _attendanceRow(
    String name,
    String position,
    Color color,
    String status,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/profile.png'),
      ), // Replace with NetworkImage or Asset
      title: Text(name),
      subtitle: Text(position),
      trailing: Chip(
        label: Text(status),
        backgroundColor: color.withOpacity(0.2),
        labelStyle: TextStyle(color: color),
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.videocam, color: Color(0xff3055a3)),
            label: Text(
              "Start Stream",
              style: TextStyle(color: Color(0xff3055a3)),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xfff1e60e)),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.insert_chart, color: Color(0xfff1e60e)),
            label: Text(
              "Live Stats",
              style: TextStyle(color: Color(0xfff1e60e)),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3055a3)),
          ),
        ),
      ],
    );
  }

  Widget _coachNotesCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Coach Notes", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Focus on possession and quick passing.\nEagles are strong on counter-attacks, so maintain defensive shape.",
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.edit, color: Color(0xff3055a3)),
              label: Text(
                "Edit Notes",
                style: TextStyle(color: Color(0xff3055a3)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
