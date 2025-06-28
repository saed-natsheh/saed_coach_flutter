import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saed_coach/models/models.dart';

class ClubService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createClub(Club club) async {
    await _firestore.collection('clubs').doc(club.id).set(club.toMap());
  }

  Future<void> updateClub(Club club) async {
    await _firestore.collection('clubs').doc(club.id).update(club.toMap());
  }

  Future<void> deleteClub(String clubId) async {
    await _firestore.collection('clubs').doc(clubId).delete();
  }

  Stream<List<Club>> getClubs() {
    return _firestore.collection('clubs').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Club.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<Club?> getClub(String clubId) async {
    final doc = await _firestore.collection('clubs').doc(clubId).get();
    return doc.exists ? Club.fromMap(doc.id, doc.data()!) : null;
  }

  Future<void> addPlayerToClub(String clubId, String playerId) async {
    await _firestore.collection('clubs').doc(clubId).update({
      'playerIds': FieldValue.arrayUnion([playerId]),
    });
  }

  Future<void> removePlayerFromClub(String clubId, String playerId) async {
    await _firestore.collection('clubs').doc(clubId).update({
      'playerIds': FieldValue.arrayRemove([playerId]),
    });
  }
}
