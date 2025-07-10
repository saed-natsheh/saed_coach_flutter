import 'package:flutter/material.dart';
import 'package:saed_coach/models/models.dart';
import 'package:saed_coach/screens/games/PlayerServices.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDetailsPage extends StatefulWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  final PlayerService _playerService = PlayerService();
  List<Player> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      final playersList = await _playerService.getPlayersByClub(widget.game.homeClubId).first;
      setState(() {
        players = playersList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching players: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchMaps(String address) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
 

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Details'),
        centerTitle: true,
        actions: [Icon(Icons.more_vert)],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
      color: Color(0xff3055a3).withOpacity(0.4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.game.title,
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
                     widget.game.date!.toString(),
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
                      widget.game.time,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    widget.game.status.toUpperCase(),
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
        title: Text(widget.game.venue.name),
        subtitle: Text(widget.game.venue.address),
        trailing: Text(
          'Get Directions',
          style: TextStyle(color: Color(0xff3055a3)),
        ),
        onTap: () => _launchMaps(widget.game.venue.address),
      ),
    );
  }

  Widget _startingLineupCard() {
    final lineupPlayers = players.where((player) => widget.game.lineup.contains(player.id)).toList();
    
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
                  '${lineupPlayers.length}/11 Confirmed',
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
                  children: lineupPlayers.take(11).map((player) => 
                    _playerCircle(
                      player.number.toString(), 
                      player.name.split(' ').last,
                      isKeeper: player.position.toLowerCase().contains('keeper')
                    )
                  ).toList(),
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
            ...players.map((player) {
              final status = widget.game.attendance.contains(player.id) 
                  ? "Confirmed" 
                  : "Pending";
              final color = status == "Confirmed" 
                  ? Color(0xff3055a3) 
                  : Color(0xfff1e60e);
              
              return _attendanceRow(
                player.name,
                "${player.position} • #${player.number}",
                color,
                status,
              );
            }).toList(),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {}, 
              child: Text("Update Attendance")
            ),
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
        child: Text(name[0]), // First letter of name
      ),
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
        )),
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
              widget.game.coachNotes.isNotEmpty 
                  ? widget.game.coachNotes 
                  : "No notes available",
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