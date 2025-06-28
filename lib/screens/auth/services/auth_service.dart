import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user?.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Save user data to shared preferences
      await _saveUserDataToPrefs(
        credential.user?.uid,
        name,
        email,
        credential.user?.emailVerified,
      );

      return credential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(credential.user?.uid)
          .get();

      if (userDoc.exists) {
        await _saveUserDataToPrefs(
          credential.user?.uid,
          userDoc['name'],
          email,
          credential.user?.emailVerified,
        );
      }

      return credential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _saveUserDataToPrefs(
    String? uid,
    String? name,
    String? email,
    bool? isVerified,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid ?? '');
    await prefs.setString('name', name ?? '');
    await prefs.setString('email', email ?? '');
    await prefs.setBool('isVerified', isVerified ?? false);
    await prefs.setBool('isLoggedIn', true);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'uid': prefs.getString('uid') ?? '',
      'name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
      'isVerified': prefs.getBool('isVerified') ?? false,
    };
  }

  Future<void> logout() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
