import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  final String apiKey;

  DirectionsRepository({required this.apiKey});

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': apiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Directions.fromMap(data);
    } else {
      return null;
    }
  }
}

class Directions {
  final List<LatLng> polylinePoints;

  Directions({required this.polylinePoints});

  factory Directions.fromMap(Map<String, dynamic> map) {
    final List points = decodePoly(map['routes'][0]['overview_polyline']['points']);
    final List<LatLng> _coordinates = <LatLng>[];
    for (final point in points) {
      _coordinates.add(LatLng(point[0], point[1]));
    }
    return Directions(polylinePoints: _coordinates);
  }

  static List decodePoly(String encoded) {
    List poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add([lat / 1E5, lng / 1E5]);
    }

    return poly;
  }
}

