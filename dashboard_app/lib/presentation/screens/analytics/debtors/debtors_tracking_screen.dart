import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dashboard_app/domain/entities/client.dart';
import 'package:dashboard_app/domain/entities/debt.dart';

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
  Future<Position> _getCurrentLocation() async {
    Position currentLocation;
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

    currentLocation = await Geolocator.getCurrentPosition();
    
    return currentLocation;
  }

  Set<Marker> _getMarkers(List<Debt> clientsDebts) {
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

  _getOptimumRoute(Set<Marker> clientsLocations) async {
    Map<int, Map<int, double>> routes = {};

    for(int iteration = 0; iteration < clientsLocations.length; iteration++) {
      Map<int, double> distances = {};
      LatLng locationPosition = clientsLocations.elementAt(iteration).position;

      for(int cicle = 0; iteration < clientsLocations.length; cicle++) {
        if (iteration == cicle) continue;

        LatLng destinationPosition = clientsLocations.elementAt(cicle).position;
        double distanceInMeters = Geolocator.bearingBetween(
          locationPosition.latitude,
          locationPosition.longitude,
          destinationPosition.latitude,
          destinationPosition.longitude
        );

        distances.addAll({cicle: distanceInMeters});
      }

      routes.addAll({iteration: distances});
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> locationMarkers = _getMarkers(widget.clientsDebts);
    late PolylinePoints routePoints;
    
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