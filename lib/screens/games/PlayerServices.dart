import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:saed_coach/models/models.dart';

class PlayerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPlayer(Player player) async {
    await _firestore.collection('players').doc(player.id).set(player.toMap());
  }

  Future<void> updatePlayer(Player player) async {
    await _firestore
        .collection('players')
        .doc(player.id)
        .update(player.toMap());
  }

  Future<void> deletePlayer(String playerId) async {
    await _firestore.collection('players').doc(playerId).delete();
  }

  Stream<List<Player>> getPlayers() {
    return _firestore.collection('players').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Player.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<Player?> getPlayer(String playerId) async {
    final doc = await _firestore.collection('players').doc(playerId).get();
    return doc.exists ? Player.fromMap(doc.id, doc.data()!) : null;
  }

  Stream<List<Player>> getPlayersByClub(String clubId) {
    return _firestore
        .collection('players')
        .where('clubId', isEqualTo: clubId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Player.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Future<int> getPlayersCountByClub(String clubId) async {
    var query = await _firestore
        .collection('players')
        .where('clubId', isEqualTo: clubId)
        .get();
    return query.docs.length;
  }
}
