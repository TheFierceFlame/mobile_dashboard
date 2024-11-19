import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
  });

  factory Directions.fromJSON(Map<String, dynamic> JSON) {
    if((JSON['routes'] as List).isEmpty) {
      return Directions(
        bounds: LatLngBounds(
          southwest: const LatLng(0, 0),
          northeast: const LatLng(0, 0)
        ),
        polylinePoints: [],
        totalDistance: '',
      );
    }

    final data = Map<String, dynamic>.from(JSON['routes'][0]);
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng'])
    );
    final distance = data['legs'][0]['distance']['text'];

    return Directions(
      bounds: bounds,
      polylinePoints: PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance
    );
  }
}