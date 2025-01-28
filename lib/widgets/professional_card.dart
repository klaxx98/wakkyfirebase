import 'package:flutter/material.dart';

/*
* CARTA DE PROFESIONAL
*/

class ProfessionalCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final int contracts;
  final VoidCallback onTap;

  ProfessionalCard({
    required this.name,
    required this.imagePath,
    required this.contracts,
    required this.onTap,
  });

/*
* BOTON DE PROFESIONAL
*/

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,  // Ejecuta la navegación cuando se toca la tarjeta
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Foto de perfil
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 16),
              // Nombre del profesional y número de contrataciones
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$contracts contrataciones',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}