import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/history_screen.dart';
import 'package:wakkyfirebase/screens/pc_screen.dart';
import 'package:wakkyfirebase/screens/profile_screen.dart';
import 'package:wakkyfirebase/screens/smartphone_screen.dart';

/*
* PANTALLA PRINCIPAL
*/

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'LA MEJOR AYUDA PROFESIONAL EN LO QUE NECESITES',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Busco ayuda en...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PCScreen()),
                );
              },
              child: Text('COMPUTADORAS'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SmartphoneScreen()),
                );
              },
              child: Text('SMARTPHONES'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historial',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navegar a la pantalla de perfil
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          } else if (index == 1) {
            // Navegar a la pantalla de historial
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          }
        },
      ),
    );
  }
}