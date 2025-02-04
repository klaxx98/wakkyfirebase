import 'package:http/http.dart' as http;
import 'dart:convert';

class GeocodingService {
  final String apiKey; //API Key de Google Maps

  GeocodingService(this.apiKey);

  // Función para convertir una dirección en coordenadas
  Future<Map<String, double>> getCoordinates(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        throw Exception('No se encontraron resultados para la dirección.');
      }
    } else {
      throw Exception('Error al conectar con la API de Geocodificación.');
    }
  }
}