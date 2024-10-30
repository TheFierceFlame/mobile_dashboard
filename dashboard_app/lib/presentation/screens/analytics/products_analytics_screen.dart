import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

class ProductsAnalyticsScreen extends ConsumerStatefulWidget {
  const ProductsAnalyticsScreen({super.key});

  @override
  ProductsAnalyticsScreenState createState() => ProductsAnalyticsScreenState();
}

class ProductsAnalyticsScreenState extends ConsumerState<ProductsAnalyticsScreen> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    ref.read(productsSalesProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(productsLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    final productsSales = ref.watch(productsSalesProvider);
    ProductsReportChart topProductosVentas = ProductsReportChart(productsSalesData: productsSales);

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
                  const Text('Productos vendidos', style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18
                  )),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 600,
                      width: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: topProductosVentas
                      )
                    ),
                  ),
                  const Spacer(),
                  const CustomButton()
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: Column(
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
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 400,
        child: Material(
          color: Colors.indigo[900],
          child: InkWell(
            onTap: () {
                      
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Registrar venta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )
              )
            )
          ),
        ),
      ),
    );
  }
}