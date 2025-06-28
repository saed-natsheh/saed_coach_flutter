import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saed_coach/models/models.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createGame(Game game) async {
    await _firestore.collection('games').doc(game.id).set(game.toMap());
  }

  Future<void> updateGame(Game game) async {
    await _firestore.collection('games').doc(game.id).update(game.toMap());
  }

  Future<void> deleteGame(String gameId) async {
    await _firestore.collection('games').doc(gameId).delete();
  }

  Future<List<Club>> getAllClubs() async {
    final snapshot = await _firestore.collection('clubs').get();
    return snapshot.docs
        .map((doc) => Club.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> assignClubsToGame(
    String gameId,
    String homeClubId,
    String awayClubId,
  ) async {
    await _firestore.collection('games').doc(gameId).update({
      'homeClubId': homeClubId,
      'awayClubId': awayClubId,
    });
  }

  Future<void> updateGameScore(
    String gameId,
    int? homeScore,
    int? awayScore,
  ) async {
    await _firestore.collection('games').doc(gameId).update({
      'homeScore': homeScore,
      'awayScore': awayScore,
    });
  }

  Stream<List<Game>> getGames() {
    return _firestore.collection('games').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<Game?> getGame(String gameId) async {
    final doc = await _firestore.collection('games').doc(gameId).get();
    return doc.exists ? Game.fromMap(doc.id, doc.data()!) : null;
  }
}
