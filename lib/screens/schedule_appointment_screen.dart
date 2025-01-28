import 'package:flutter/material.dart';

/*
* PANTALLA DE AGENDAR CITA
*/

class ScheduleAppointmentScreen extends StatelessWidget {
  final String proName;
  final String imagePath;

  ScheduleAppointmentScreen({
    required this.proName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: Foto del profesional y su nombre
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imagePath),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    proName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Mensaje personalizado del profesional
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
                color: Colors.grey[100],
              ),
              child: Text(
                'Ofrezco servicios de mantenimiento de máquina, instalación y actualización de software y hardware. '
                'Venta de periféricos y componentes. Precio inicial por diagnóstico: \$5',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Spacer(),
            // Botón de agendar cita
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Mostrar AlertDialog al presionar el botón
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Cita agendada',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text('Espera confirmación del profesional'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el AlertDialog
                          },
                          child: Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  backgroundColor: Colors.blueAccent, // Color del botón
                ),
                child: Text(
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