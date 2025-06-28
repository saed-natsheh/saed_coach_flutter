import 'package:flutter/material.dart';
import 'package:saed_coach/Myapp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBNVTLlnXWDjdtAqs54mrlnCkMAOIRISQE",
      appId: "1:1073987209432:android:df93a263ff3c33172fefad",
      projectId: "saedcoach",
      messagingSenderId: "1073987209432",
    ),
  );
  runApp(const SaedApp());
}
