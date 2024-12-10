import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

class ProductsPredictionScreen extends ConsumerStatefulWidget {
  const ProductsPredictionScreen({super.key});

  @override
  ProductsPredictionScreenState createState() => ProductsPredictionScreenState();
}

class ProductsPredictionScreenState extends ConsumerState<ProductsPredictionScreen> {
  final storageProductsPredictionAsync = FutureProvider.autoDispose<List<Prediction>>((ref) async {
    final productsPredictionsData = await ref.read(predictionsProvider.notifier).loadPredictions();

    return productsPredictionsData;
  });

  @override
  Widget build(BuildContext context) {
    final productsPredictions = ref.watch(storageProductsPredictionAsync);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        centerTitle: true,
        title: const Text(
          'Predicción de ventas',
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
      body: productsPredictions.when(
        data: (productsPredictions) {
          return Center(
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
                      const Text('Tendencias de venta a seis meses', style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18
                      )),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 550,
                          width: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: SalesTendenciesChart(salesPredictionsData: productsPredictions)
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (_, __) => const CircularProgressIndicator(),
        loading: () => const CircularProgressIndicator()
      )
    );
  }
}