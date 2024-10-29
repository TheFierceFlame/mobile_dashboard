import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

class ProductsAnalyticsScreen extends ConsumerStatefulWidget {
  const ProductsAnalyticsScreen({super.key});

  @override
  ProductsAnalyticsScreenState createState() => ProductsAnalyticsScreenState();
}

class ProductsAnalyticsScreenState extends ConsumerState<ProductsAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(dailySalesProvider.notifier).loadData(ref.read(dailySalesFiltersProvider));
    ref.read(weeklySalesProvider.notifier).loadData(ref.read(weeklySalesFiltersProvider));
    ref.read(monthlySalesProvider.notifier).loadData(ref.read(monthlySalesFiltersProvider));
    ref.read(topSellingProductsProvider.notifier).loadData(ref.read(topSellingProductsFiltersProvider));
    ref.read(topBuyingCustomersProvider.notifier).loadData(ref.read(topBuyingCustomersFiltersProvider));
  }

  @override
  Widget build(BuildContext context) {
    final topSellingProducts = ref.watch(topSellingProductsProvider);
    TopSellingProductsChart topProductosVentas = TopSellingProductsChart(topSellingProductsData: topSellingProducts);

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        title: const Text(
          'Reporte de venta por línea',
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const Text('Productos vendidos', style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 18
                        )),
                  const SizedBox(height: 20),
                  Container(
                    height: 252,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: topProductosVentas
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "FloatingActionButtonPopulate",
            backgroundColor: Colors.indigo[900],
            onPressed: () {

            },
            child: const Icon(Icons.add_box_rounded),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "FloatingActionButtonErase",
            backgroundColor: Colors.indigo[900],
            onPressed: () {

            },
            child: const Icon(Icons.remove_circle_outlined),
          )
        ],
      ),
    );
  }
}