import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/schedule_appointment_screen.dart';

/*
* PANTALLA DE PERFIL DE PROFESIONAL
*/

class ViewProScreen extends StatelessWidget {
  final String proName;
  final String imagePath;
  final int successfulContracts;
  final String address;
  final int positiveReviews;

  ViewProScreen({
    required this.proName,
    required this.imagePath,
    required this.successfulContracts,
    required this.address,
    required this.positiveReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Profesional'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de perfil y nombre
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(imagePath),
                    ),
                    SizedBox(height: 8),
                    Text(
                      proName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Acerca de
              Text(
                'Acerca de $proName',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Descripción de $proName'),
              SizedBox(height: 16),
              // Desempeño general
              Text(
                'Desempeño general',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏆 $successfulContracts contrataciones exitosas',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🌎 $address',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '🥇 $positiveReviews valoraciones positivas de los usuarios',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              // Agendar cita
              Center(
                child: Column(
                  children: [
                    Text(
                      'AGENDA TU CITA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Navegar a la pantalla de agendar cita
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScheduleAppointmentScreen(
                              proName: proName,
                              imagePath: imagePath,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text(
                        'Contactar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}