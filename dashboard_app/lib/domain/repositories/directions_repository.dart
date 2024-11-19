import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dashboard_app/infrastructure/models/directions.dart';

class DirectionsRepository {
  static const String url = 'https://maps.googleapis.com/maps/api/directions/json?';
  final Dio http = Dio();

  DirectionsRepository();

  Future<Directions> getDirections(LatLng origin, LatLng destination) async {
    final response = await http.get(
      url,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'mode': 'driving',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyBx0v94W-mzWbSRwGbAQ-CXGawKSGj0_3E'
      }
    );

    if(response.statusCode == 200) {
      return Directions.fromJSON(response.data);
    }
    
    return Directions(
      bounds: LatLngBounds(
        southwest: const LatLng(0, 0),
        northeast: const LatLng(0, 0)
      ),
      polylinePoints: [],
      totalDistance: '',
    );
  }
}