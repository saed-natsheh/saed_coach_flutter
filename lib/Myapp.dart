import 'package:flutter/material.dart';
import 'package:saed_coach/models/models.dart' show Game;
import 'package:saed_coach/screens/GameDetialsScreen.dart';
import 'package:saed_coach/screens/admin/AdminDashboard.dart';
import 'package:saed_coach/screens/auth/LoginScreen.dart';
import 'package:saed_coach/screens/auth/RegistrationScreen.dart';
import 'package:saed_coach/screens/games/ClubServices.dart';
import 'package:saed_coach/screens/games/GameServices.dart';
import 'package:saed_coach/screens/games/PlayerServices.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GameService _gameService = GameService();
  final ClubService _clubService = ClubService();
  final PlayerService _playerService = PlayerService();
  
  String pageName = 'Rungis';
  int totalTeams = 0;
  int totalGames = 0;
  int totalPlayers = 0;
  Game? nextGame;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch all clubs to get team count
      final clubs = await _clubService.getClubs().first;
      setState(() {
        totalTeams = clubs.length;
      });

      // Fetch all players to get player count
      final players = await _playerService.getPlayers().first;
      setState(() {
        totalPlayers = players.length;
      });

      // Fetch all games to get game count and find next game
      final games = await _gameService.getGames().first;
      setState(() {
        totalGames = games.length;
        // Find the next upcoming game
        final now = DateTime.now();
        final upcomingGames = games.where((game) => game.date.isAfter(now)).toList();
        if (upcomingGames.isNotEmpty) {
          upcomingGames.sort((a, b) => a.date.compareTo(b.date));
          nextGame = upcomingGames.first;
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xff3055a3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.sports_soccer, size: 48, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    'Rungis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('AdminDashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_main.png', height: 30),
            SizedBox(width: 6),
            Text(pageName),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard(
                        icon: Icons.people,
                        value: totalTeams.toString(),
                        label: 'Teams',
                      ),
                      _buildStatCard(
                        icon: Icons.calendar_month,
                        value: totalGames.toString(),
                        label: 'Games',
                      ),
                      _buildStatCard(
                        icon: Icons.person,
                        value: totalPlayers.toString(),
                        label: 'Players',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (nextGame != null) _buildNextGameCard(nextGame!),
                  SizedBox(height: 16),
                  _buildLineupCard(),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("club news"), Text("see all")],
                  ),
                  SizedBox(height: 16),
                  _buildNewsCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xff3055a3)),
          SizedBox(height: 6),
          Text(value),
          SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildNextGameCard(Game game) {
    // final dateFormat = DateFormat('EEE d MMM');
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: Offset(0, 1),
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
                  color: Color(0xff3055a3).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(game.date.toString()),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.security, color: Color(0xff3055a3), size: 36),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${game.title}'),
                  Text(game.venue.name),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameDetailsPage(game: game),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff3055a3).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text('Details')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineupCard() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: Offset(0, 1),
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
       
        ],
      ),
    );
  }

  Widget _buildNewsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 1,
            offset: Offset(0, 1),
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
              Text("ensure your child"),
            ],
          ),
        ],
      ),
    );
  }
}