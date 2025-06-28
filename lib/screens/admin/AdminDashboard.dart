import 'package:flutter/material.dart';
import 'package:saed_coach/models/models.dart';
import 'package:saed_coach/screens/admin/ClubForm.dart';
import 'package:saed_coach/screens/admin/GameForm.dart';
import 'package:saed_coach/screens/admin/PlayerForm.dart';
import 'package:saed_coach/screens/games/ClubServices.dart';
import 'package:saed_coach/screens/games/GameServices.dart';
import 'package:saed_coach/screens/games/PlayerServices.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final GameService _gameService = GameService();
  final ClubService _clubService = ClubService();
  final PlayerService _playerService = PlayerService();
  final List<String> tabs = ['Games', 'Clubs', 'Players'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                switch (_tabController.index) {
                  case 0:
                    _showAddGameDialog();
                    break;
                  case 1:
                    _showAddClubDialog();
                    break;
                  case 2:
                    _showAddPlayerDialog();
                    break;
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [_buildGamesTab(), _buildClubsTab(), _buildPlayersTab()],
        ),
      ),
    );
  }

  Widget _buildGamesTab() {
    return StreamBuilder<List<Game>>(
      stream: _gameService.getGames(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final games = snapshot.data ?? [];
        if (games.isEmpty) {
          return const Center(child: Text('No games found'));
        }

        return ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  game.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: FutureBuilder(
                  future: Future.wait([
                    _clubService.getClub(game.homeClubId),
                    _clubService.getClub(game.awayClubId),
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final homeClub = snapshot.data?[0];
                      final awayClub = snapshot.data?[1];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${homeClub?.name ?? 'Unknown'} vs ${awayClub?.name ?? 'Unknown'}',
                          ),
                          if (game.homeScore != null && game.awayScore != null)
                            Text(
                              'Score: ${game.homeScore} - ${game.awayScore}',
                            ),
                          Text(
                            '${game.date.toString().split(' ')[0]} at ${game.time}',
                          ),
                        ],
                      );
                    }
                    return const Text('Loading clubs...');
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditGameDialog(game),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteGame(game.id),
                    ),
                  ],
                ),
                onTap: () => _showGameDetails(game),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClubsTab() {
    return StreamBuilder<List<Club>>(
      stream: _clubService.getClubs(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final clubs = snapshot.data ?? [];
        if (clubs.isEmpty) {
          return const Center(child: Text('No clubs found'));
        }

        return ListView.builder(
          itemCount: clubs.length,
          itemBuilder: (context, index) {
            final club = clubs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: club.logoUrl.isNotEmpty
                      ? NetworkImage(club.logoUrl)
                      : const AssetImage('assets/default_club.png')
                            as ImageProvider,
                ),
                title: Text(
                  club.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(club.address),
                    FutureBuilder<int>(
                      future: _playerService.getPlayersCountByClub(club.id),
                      builder: (context, snapshot) {
                        return Text(
                          'Players: ${snapshot.data ?? 0}',
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditClubDialog(club),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteClub(club.id),
                    ),
                  ],
                ),
                onTap: () => _showClubDetails(club),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlayersTab() {
    return StreamBuilder<List<Player>>(
      stream: _playerService.getPlayers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final players = snapshot.data ?? [];
        if (players.isEmpty) {
          return const Center(child: Text('No players found'));
        }

        return ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: player.photoUrl.isNotEmpty
                      ? NetworkImage(player.photoUrl)
                      : const AssetImage('assets/default_player.jpg')
                            as ImageProvider,
                ),
                title: Text(
                  player.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: FutureBuilder<Club?>(
                  future: _clubService.getClub(player.clubId),
                  builder: (context, snapshot) {
                    return Text(
                      '${player.position} - #${player.number} • ${snapshot.data?.name ?? 'Unknown Club'}',
                    );
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditPlayerDialog(player),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePlayer(player.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Game Dialog Methods
  void _showAddGameDialog() async {
    final clubs = await _clubService.getClubs().first;
    if (mounted && clubs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add New Game'),
          content: SizedBox(
            width: double.maxFinite,
            child: GameForm(
              clubs: clubs,
              onSubmit: (game) async {
                await _gameService.createGame(game);
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No clubs available. Please add clubs first.'),
        ),
      );
    }
  }

  void _showEditGameDialog(Game game) async {
    final clubs = await _clubService.getClubs().first;
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit Game'),
          content: SizedBox(
            width: double.maxFinite,
            child: GameForm(
              game: game,
              clubs: clubs,
              onSubmit: (updatedGame) async {
                await _gameService.updateGame(updatedGame);
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ),
        ),
      );
    }
  }

  Future<void> _deleteGame(String gameId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Game?'),
        content: const Text('Are you sure you want to delete this game?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _gameService.deleteGame(gameId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game deleted successfully')),
      );
    }
  }

  // Club Dialog Methods
  void _showAddClubDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Club'),
        content: ClubForm(
          onSubmit: (club) async {
            await _clubService.createClub(club);
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showEditClubDialog(Club club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Club'),
        content: ClubForm(
          club: club,
          onSubmit: (updatedClub) async {
            await _clubService.updateClub(updatedClub);
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _deleteClub(String clubId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Club?'),
        content: const Text(
          'This will also remove all associated players. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _clubService.deleteClub(clubId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Club deleted successfully')),
      );
    }
  }

  // Player Dialog Methods
  void _showAddPlayerDialog() async {
    final clubs = await _clubService.getClubs().first;
    if (mounted && clubs.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add New Player'),
          content: PlayerForm(
            clubs: clubs,
            onSubmit: (player) async {
              await _playerService.createPlayer(player);
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No clubs available. Please add clubs first.'),
        ),
      );
    }
  }

  void _showEditPlayerDialog(Player player) async {
    final clubs = await _clubService.getClubs().first;
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit Player'),
          content: PlayerForm(
            player: player,
            clubs: clubs,
            onSubmit: (updatedPlayer) async {
              await _playerService.updatePlayer(updatedPlayer);
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
    }
  }

  Future<void> _deletePlayer(String playerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Player?'),
        content: const Text('Are you sure you want to delete this player?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _playerService.deletePlayer(playerId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player deleted successfully')),
      );
    }
  }

  // Detail View Methods
  void _showGameDetails(Game game) {
    // Implement game details view
  }

  void _showClubDetails(Club club) {
    // Implement club details view
  }
}
