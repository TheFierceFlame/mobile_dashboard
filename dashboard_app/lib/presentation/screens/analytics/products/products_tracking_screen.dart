import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

class ProductsTrackingScreen extends ConsumerStatefulWidget {
  const ProductsTrackingScreen({super.key});
  
  @override
  ProductsTrackingScreenState createState() => ProductsTrackingScreenState();
}

class ProductsTrackingScreenState extends ConsumerState<ProductsTrackingScreen> {
  final storageProductsSalesAsync = FutureProvider<List<Product>>((ref) async {
    final productsSalesData = await ref.read(storageProductsSalesProvider.notifier).searchSales(ref.watch(storageProductsSalesFiltersProvider));

    return productsSalesData;
  });

  _getMarkers(List<Product> productsSales) {
    Set<Marker> markers = {};

    for(final (index, product) in productsSales.indexed) {
      var latitude = double.parse(product.coordinates.split(',')[0]);
      var longitude = double.parse(product.coordinates.split(',')[1]);

      markers.add(Marker(
        markerId: MarkerId('$index'),
        infoWindow: InfoWindow(title: product.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(latitude, longitude)
      ));
    }

    return markers;
  }

  _filterProductsSales(String date) async {
    ref.read(storageProductsSalesFiltersProvider.notifier).update((state) => DateTime.parse(date));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productsSalesData = ref.watch(storageProductsSalesAsync);
    DateTime productsSalesDate = ref.watch(storageProductsSalesFiltersProvider);
    Set<Marker> locationMarkers = {};
    
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
        child: productsSalesData.when(
          data: (productsSales) {
            locationMarkers = _getMarkers(productsSales);

            return Column(
              children: [
                Container(
                  color: Colors.indigo[900],
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Text(
                          'Registros del ${DateFormat('dd/MM/yyyy').format(productsSalesDate)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )
                        ),
                        const Spacer(),
                        IconButton(
                          color: Colors.white,
                          onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ProductsTrackingFilters(callBack: _filterProductsSales);
                            },
                          ),
                          icon: const Icon(Icons.filter_list),
                        )
                      ]
                    )
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(25.790466, -108.985886),
                      zoom: 13
                    ),
                    markers: locationMarkers,
                  ),
                )
              ],
            );
          },
          error: (_, __) => const FullScreenLoader(),
          loading: () => const FullScreenLoader() 
        )
      )
    );
  }
}