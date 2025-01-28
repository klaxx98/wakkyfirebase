import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(WakkyApp());
  });
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

/*
List usuarios = [];

@override
void initState() {
  super.initState();
  getUsers();
}

void getUsers() async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
  QuerySnapshot users = await collectionReference.get();

  if (users.docs.length != 0) {
    for (var doc in users.docs) {
      print(doc.data());
      usuarios.add(doc.data());
    }
  }
}
*/