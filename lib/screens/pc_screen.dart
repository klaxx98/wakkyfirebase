import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:wakkyfirebase/screens/viewpro_screen.dart';
import 'package:wakkyfirebase/widgets/geocoding_service.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'dart:math';

/*
* PANTALLA DE SERVICIO COMPUTACION
*/

class PCScreen extends StatefulWidget {
  @override
  _PCScreenState createState() => _PCScreenState();
}

class _PCScreenState extends State<PCScreen> {
  String postalAddress = "";
  List<Map<String, dynamic>> professionals = [];
  bool _isLoading = false;
  Map<String, double>? _userCoordinates; // Coordenadas del usuario
  final GeocodingService _geocodingService = GeocodingService('AIzaSyCqbmaOA7_cDOM3i6lHz3WDOoQoAnjQRS4');
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCqbmaOA7_cDOM3i6lHz3WDOoQoAnjQRS4');

  @override
  void initState() {
    super.initState();
    fetchProfessionals();
  }

  Future<void> fetchProfessionals() async {
    try {
      // Consultar la colección 'professionals' donde el campo 'job' incluye 'computacion'
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('professionals')
          .where('job', arrayContains: 'computacion')
          .get();

      // Convertir los documentos en una lista
      List<Map<String, dynamic>> fetchedProfessionals = snapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'mail': doc['mail'],
                'address': doc['address'],
                'location': doc['location'], // Coordenadas del profesional
                'hirings': doc['hirings'], // Número de contrataciones exitosas
                'rating': doc['rating'], // Valoración promedio
                'description': doc['description'], // Descripción del profesional
              })
          .toList();

      setState(() {
        professionals = fetchedProfessionals;
      });
    } catch (e) {
      print("Error al cargar los profesionales: $e");
    }
  }

  // Función para obtener las coordenadas del usuario
  Future<void> _getUserCoordinates() async {
    if (postalAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa una dirección.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final coordinates = await _geocodingService.getCoordinates(postalAddress);
      setState(() {
        _userCoordinates = coordinates;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para mostrar el autocompletado de direcciones
  Future<void> _showAddressAutocomplete() async {
    final Prediction? prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyCqbmaOA7_cDOM3i6lHz3WDOoQoAnjQRS4', // Reemplaza con tu API Key
      mode: Mode.overlay, // Modo de visualización
      language: 'es', // Idioma
    );

    if (prediction != null) {
      final details = await _places.getDetailsByPlaceId(prediction.placeId!);
      final address = details.result.formattedAddress;
      setState(() {
        postalAddress = address ?? '';
      });
    }
  }

  // Función para calcular la distancia entre dos coordenadas
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Radio de la Tierra en km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distancia en km
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Función para ordenar profesionales por cercanía
  List<Map<String, dynamic>> _sortProfessionalsByDistance() {
    if (_userCoordinates == null) return professionals;

    return professionals.map((pro) {
      final proLocation = pro['location'] as GeoPoint;
      final distance = _calculateDistance(
        _userCoordinates!['latitude']!,
        _userCoordinates!['longitude']!,
        proLocation.latitude,
        proLocation.longitude,
      );
      return {
        ...pro,
        'distance': distance, // Agregar la distancia al mapa del profesional
      };
    }).toList()
      ..sort((a, b) => a['distance'].compareTo(b['distance'])); // Ordenar por distancia
  }

  @override
  Widget build(BuildContext context) {
    final sortedProfessionals = _sortProfessionalsByDistance();

    return Scaffold(
      appBar: AppBar(
        title: Text('Técnico de Computadoras'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encuentra servicio técnico para tu computador de escritorio o portátil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text('Mi dirección...'),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: postalAddress),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ingresa tu dirección',
                    ),
                    onTap: _showAddressAutocomplete, // Mostrar autocompletado al tocar el campo
                    readOnly: true, // Evitar que el usuario edite manualmente
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _getUserCoordinates,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Continuar'),
                ),
              ],
            ),
            if (_userCoordinates != null) ...[
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
                child: sortedProfessionals.isEmpty
                    ? Center(child: Text('No hay profesionales disponibles.'))
                    : ListView.builder(
                        itemCount: sortedProfessionals.length,
                        itemBuilder: (context, index) {
                          final pro = sortedProfessionals[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('assets/profile_picture.png'),
                            ),
                            title: Text('${pro['name']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Contratos exitosos: ${pro['hirings']}'),
                                Text('Rating: ${pro['rating']?.toStringAsFixed(1) ?? "N/A"}'),
                                Text('Distancia: ${pro['distance']?.toStringAsFixed(2) ?? "N/A"} km'),
                              ],
                            ),
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