import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/viewpro_screen.dart';

/*
* PANTALLA DE SERVICIO SMARTPHONE
*/

class SmartphoneScreen extends StatefulWidget {
  @override
  _SmartphoneScreenState createState() => _SmartphoneScreenState();
}

class _SmartphoneScreenState extends State<SmartphoneScreen> {
  String postalAddress = "";
  List<Map<String, dynamic>> professionals = [];

  @override
  void initState() {
    super.initState();
    fetchProfessionals();
  }

  Future<void> fetchProfessionals() async {
    try {
      // Consultar la colección 'professionals' donde el campo 'job' incluye 'smartphone'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', arrayContains: 'smartphone')
          .get();

      // Convertir los documentos en una lista
      List<Map<String, dynamic>> fetchedProfessionals = snapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'mail': doc['mail'],
                'address': doc['address'],
                'hirings': doc['hirings'], // Número de contrataciones exitosas
                'rating': doc['rating'],   // Valoración promedio
                'description': doc['description'], //descripción del profesional
              })
          .toList();

      setState(() {
        professionals = fetchedProfessionals;
      });
    } catch (e) {
      print("Error al cargar los profesionales: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Técnico de Smartphones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encuentra servicio técnico para tu smartphone',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text('Mi dirección postal...'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      postalAddress = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ingresa tu dirección postal',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('Continuar'),
                ),
              ],
            ),
            if (postalAddress.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Profesionales cerca de ti',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: professionals.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: professionals.length,
                        itemBuilder: (context, index) {
                          final pro = professionals[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/profile_picture.png'),
                            ),
                            title: Text('${pro['name']}'),
                            subtitle: Text(
                                'Contratos exitosos: ${pro['hirings']}\nRating: ${pro['rating']?.toStringAsFixed(1) ?? "N/A"}'),
                            trailing: Icon(Icons.arrow_forward),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewProScreen(
                                    proName: pro['name'],
                                    proEmail: pro['mail'],
                                    imagePath: 'assets/profile_picture.png',
                                    successfulContracts: pro['hirings'],
                                    address: pro['address'],
                                    positiveReviews: pro['rating'],
                                    description: pro['description'] ?? 'Sin descripción',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}