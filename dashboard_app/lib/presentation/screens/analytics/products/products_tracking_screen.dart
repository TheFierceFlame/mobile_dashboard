import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';

class ProductsTrackingScreen extends ConsumerWidget {
  ProductsTrackingScreen({super.key});

  final storageProductsSalesAsync = FutureProvider<List<Product>>((ref) async {
    final productsSalesData = await ref.read(storageProductsSalesProvider.notifier).loadSales();

    return productsSalesData;
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsSalesData = ref.watch(storageProductsSalesAsync);
    String productsSalesDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Center(
        child: productsSalesData.when(
          data: (productsSales) => Column(
            children: [
              Container(
                color: Colors.indigo[900],
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Text(
                        'Registros del $productsSalesDate',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list),
                      )
                    ]
                  )
                ),
              ),
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(25.790466, -108.985886),
                  zoom: 20
                )
              )
            ],
          ),
          error: (_, __) => const FullScreenLoader(),
          loading: () => const FullScreenLoader() 
        )
      )
    );
  }
}