import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
* PANTALLA DE AGENDAR CITA CON SERVICIOS
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
  List<Map<String, dynamic>> _services = []; // Lista de servicios del profesional
  String? _selectedService; // Servicio seleccionado por el usuario
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfessionalServices(); // Cargar los servicios del profesional
  }

  // Cargar los servicios del profesional desde Firestore
  Future<void> _loadProfessionalServices() async {
    try {
      // Obtener el documento del profesional
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('mail', isEqualTo: widget.proEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var professionalData = snapshot.docs.first.data() as Map<String, dynamic>;
        if (professionalData.containsKey('services')) {
          setState(() {
            _services = List<Map<String, dynamic>>.from(professionalData['services']);
          });
        }
      }
    } catch (e) {
      print("Error al cargar los servicios: $e");
    }
  }

  // Agendar la cita con el servicio seleccionado
  void _scheduleAppointment() async {
    if (_selectedService == null) {
      _showErrorDialog('Por favor, selecciona un servicio.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _showErrorDialog('Debes iniciar sesión para agendar una cita.');
        return;
      }

      // Guardar la cita en Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'usermail': user.email, // Correo del usuario
        'promail': widget.proEmail, // Correo del profesional
        'problem': _selectedService, // Servicio seleccionado
        'timestamp': FieldValue.serverTimestamp(), // Fecha de la cita
      });

      // Mostrar mensaje de confirmación
      _showSuccessDialog('Tu cita ha sido agendada. Espera confirmación del profesional.');
    } catch (e) {
      _showErrorDialog('Ocurrió un error al agendar la cita. Inténtalo de nuevo.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // Mostrar un diálogo de éxito
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cita Agendada'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Cerrar la pantalla de agendar cita
            },
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
            // Información del profesional
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundImage: AssetImage(widget.imagePath)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.proName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Lista de servicios
            Text(
              'Servicios ofrecidos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _services.isEmpty
                  ? Center(child: Text('No hay servicios disponibles.'))
                  : ListView.builder(
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final service = _services[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(service['service'] ?? 'Servicio no especificado'),
                            subtitle: Text('\$${service['price']?.toStringAsFixed(2) ?? '0.00'}'),
                            trailing: Radio<String>(
                              value: service['service'],
                              groupValue: _selectedService,
                              onChanged: (value) {
                                setState(() {
                                  _selectedService = value;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Botón para agendar la cita
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _scheduleAppointment,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.blueAccent,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Agendar cita',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}