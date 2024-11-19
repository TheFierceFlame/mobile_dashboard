import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';
import 'package:dashboard_app/infrastructure/models/directions.dart';
import 'package:dashboard_app/domain/repositories/directions_repository.dart';

List<Color> _routesColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.pink
];

class DebtorsTrackingScreen extends ConsumerStatefulWidget {
  final List<Debt> clientsDebts;
  
  const DebtorsTrackingScreen({
    super.key,
    required this.clientsDebts
  });
  
  @override
  DebtorsTrackingScreenState createState() => DebtorsTrackingScreenState();
}

class DebtorsTrackingScreenState extends ConsumerState<DebtorsTrackingScreen> {
  late Position currentLocation;
  Set<Marker> locationMarkers = {};
  Set<Polyline> routes = {};

  Future<Position> _getCurrentLocation() async {
    Position location;
    bool serviceEnabled;
    LocationPermission permission;
                
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
                
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
                                  
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    location = await Geolocator.getCurrentPosition();
    currentLocation = location;
    locationMarkers = await _getMarkers(widget.clientsDebts);
    routes = await _getOptimumRoute(locationMarkers);
    
    return location;
  }

  Future<Set<Marker>> _getMarkers(List<Debt> clientsDebts) async {
    Set<Client> clients = {};
    Set<Marker> markers = {};

    for(var debt in clientsDebts) {
      if(debt.payment != debt.amount && clients.where((client) => client.location == debt.client.value!.location).isEmpty) {
        clients.add(debt.client.value!);
      }
    }

    for(final (index, client) in clients.indexed) {
      var latitude = double.parse(client.location.split(',')[0]);
      var longitude = double.parse(client.location.split(',')[1]);

      markers.add(Marker(
        markerId: MarkerId('$index'),
        infoWindow: InfoWindow(title: client.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(latitude, longitude)
      ));
    }

    return markers;
  }

  Future<Set<Polyline>> _getOptimumRoute(Set<Marker> clientsLocations) async {
    LatLng originPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    Set<Marker> locations = Set.from(clientsLocations);
    Set<Polyline> routePoints = {};
    int colorIndex = 0;

    for(int iteration = 0; iteration < clientsLocations.length; iteration++) {
      List<Directions> availableDirections = [];
      Map<int, double> distances = {};
      int selectedIndex = 0;
      
      for(int cicle = 0; cicle < locations.length; cicle++) {
        Directions directions = await DirectionsRepository().getDirections(
          LatLng(originPosition.latitude, originPosition.longitude),
          LatLng(
            locations.elementAt(cicle).position.latitude,
            locations.elementAt(cicle).position.longitude
          )
        );
        
        availableDirections.add(directions);
        distances.addAll({cicle: double.parse(directions.totalDistance.split('km')[0])});
      }

      double minimalDistance = double.infinity;

      for(var distance in distances.entries) {
        if(distance.value < minimalDistance) {
          minimalDistance = distance.value;
          selectedIndex = distance.key;
        }
      }
      
      originPosition = LatLng(
        locations.elementAt(selectedIndex).position.latitude,
        locations.elementAt(selectedIndex).position.longitude
      );
      locations.remove(locations.elementAt(selectedIndex));
      routePoints.add(
        Polyline(
          polylineId: PolylineId('$iteration'),
          color: _routesColors[colorIndex],
          width: 5,
          points: availableDirections[selectedIndex].polylinePoints.map((point) => LatLng(point.latitude, point.longitude)).toList()
        )
      );
      colorIndex == _routesColors.length - 1 ? colorIndex = 0 : colorIndex++;
    }

    return routePoints;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        title: const Text(
          'Rastreo de ventas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        ),
        leading: FloatingActionButton(
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange[900],
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _getCurrentLocation(),
          builder: (BuildContext context, AsyncSnapshot location) {
            if(location.hasData) {
              return Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: location.hasData ? LatLng(location.data!.latitude, location.data!.longitude) : const LatLng(25.790466, -108.985886),
                    zoom: 13
                  ),
                  myLocationEnabled: true,
                  markers: locationMarkers,
                  polylines: routes
                ),
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          }
        )
      )
    );
  }
}