import 'package:flutter/material.dart';
import 'package:wakkyfirebase/screens/viewpro_screen.dart';
import 'package:wakkyfirebase/widgets/professional_card.dart';

/*
* PANTALLAS DE SERVICIO SMARTPHONE
*/

class SmartphoneScreen extends StatefulWidget {
  @override
  _SmartphoneScreenState createState() => _SmartphoneScreenState();
}

class _SmartphoneScreenState extends State<SmartphoneScreen> {
  String postalAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio Técnico de Smartphones'),
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
                child: ListView(
                  children: [
                    ProfessionalCard(
                      name: 'Pro1',
                      contracts: 10,
                      imagePath: 'assets/profile_picture.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProScreen(
                              proName: 'Pro1',
                              imagePath: 'assets/profile_picture.png',
                              successfulContracts: 10,
                              address: 'Dirección de Pro1',
                              positiveReviews: 15,
                            ),
                          ),
                        );
                      },
                    ),
                    ProfessionalCard(
                      name: 'Pro2',
                      contracts: 10,
                      imagePath: 'assets/profile_picture.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProScreen(
                              proName: 'Pro2',
                              imagePath: 'assets/profile_picture.png',
                              successfulContracts: 10,
                              address: 'Dirección de Pro2',
                              positiveReviews: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    ProfessionalCard(
                      name: 'Pro3',
                      contracts: 10,
                      imagePath: 'assets/profile_picture.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewProScreen(
                              proName: 'Pro3',
                              imagePath: 'assets/profile_picture.png',
                              successfulContracts: 10,
                              address: 'Dirección de Pro3',
                              positiveReviews: 25,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}