import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(WakkyApp());
}

class WakkyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wakky App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // Iniciar con la pantalla de Login
    );
  }
}
