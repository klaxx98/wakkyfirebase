import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
* PANTALLA DE AGENDAR CITA
*/

class ScheduleAppointmentScreen extends StatefulWidget {
  final String proName;
  final String proEmail; // Necesario para la cita
  final String imagePath;

  ScheduleAppointmentScreen({
    required this.proName,
    required this.proEmail,
    required this.imagePath,
  });

  @override
  _ScheduleAppointmentScreenState createState() => _ScheduleAppointmentScreenState();
}

class _ScheduleAppointmentScreenState extends State<ScheduleAppointmentScreen> {
  TextEditingController problemController = TextEditingController();

  void scheduleAppointment() async {
    // Obtener el usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si no hay usuario autenticado, mostrar alerta
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Debes iniciar sesión para agendar una cita.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        ),
      );
      return;
    }

    // Guardar la cita en Firestore
    await FirebaseFirestore.instance.collection('appointments').add({
      'usermail': user.email, // Guardamos el correo del usuario logueado
      'promail': widget.proEmail, // Guardamos el correo del profesional
      'problem': problemController.text, // Descripción del problema
      'timestamp': FieldValue.serverTimestamp(), // Fecha de la cita
    });

    // Mostrar mensaje de confirmación
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cita Agendada'),
        content: Text('Tu cita ha sido agendada. Espera confirmación del profesional.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agendar Cita')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundImage: AssetImage(widget.imagePath)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(widget.proName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: problemController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe tu problema...',
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: scheduleAppointment,
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
                child: Text('Agendar cita', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}