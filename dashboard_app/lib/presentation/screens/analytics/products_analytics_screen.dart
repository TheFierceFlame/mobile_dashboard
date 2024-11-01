import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

class ProductsAnalyticsScreen extends ConsumerStatefulWidget {
  const ProductsAnalyticsScreen({super.key});

  @override
  ProductsAnalyticsScreenState createState() => ProductsAnalyticsScreenState();
}

class ProductsAnalyticsScreenState extends ConsumerState<ProductsAnalyticsScreen> {
  bool loading = true;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  List<String> _productsCategories = [];
  List<String> _productsNames = [];
  List<double> _productsPrices = [];

  @override
  void initState() {
    super.initState();
    ref.read(storageProductsSalesProvider.notifier).loadSales();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(storageProductsSalesLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    final productsSales = ref.watch(storageProductsSalesProvider);
    ProductsReportChart topProductosVentas = ProductsReportChart(productsSalesData: productsSales);
    
    _productsCategories = [];
    _productsNames = [];
    _productsPrices = [];
    _getProductsData(productsSales);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey,
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
                      CustomButton(panelController: panelController),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: FloatingActionButton(
              heroTag: "FloatingActionButtonRefresh",
              backgroundColor: Colors.indigo[900],
              onPressed: () {
                        
              },
              child: const Icon(Icons.refresh_outlined),
            ),
          ),
        ),
         _CustomSlidingUpPanel(
          panelController: panelController,
          productsCategories: _productsCategories,
          productsNames: _productsNames,
          productsPrices: _productsPrices,
          callback: _addProductSale,
        )
      ]
    );
  }

  _getProductsData(List<Product> productsSales) {
    List<Map<String, double>> productsData = [{'Sin seleccionar' : 0.0}];

    _productsCategories.add('Sin categoria');

    for(var product in productsSales) {
      if(!productsData.any((element) => element.keys.toList()[0] == product.name)) {
        _productsCategories.add(product.category);
        productsData.add({product.name : product.price});
      }
    }

    for(var element in productsData) {
      _productsNames.add(element.keys.toList()[0]);
      _productsPrices.add(element.values.toList()[0]);
    }
  }

  _addProductSale(Product product) async {
    await ref.read(storageProductsSalesProvider.notifier).insertProduct(product);
    await ref.read(storageProductsSalesProvider.notifier).loadSales();
  }
}

class CustomButton extends StatelessWidget {
  final SlidingUpPanelController panelController;

  const CustomButton({
    super.key,
    required this.panelController
  });

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
              panelController.anchor();
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

class _CustomSlidingUpPanel extends StatefulWidget {
  final SlidingUpPanelController panelController;
  final List<String> productsCategories;
  final List<String> productsNames;
  final List<double> productsPrices;
  final Function callback;

  const _CustomSlidingUpPanel({
    required this.panelController,
    required this.productsCategories,
    required this.productsNames,
    required this.productsPrices,
    required this.callback
  });

  @override
  State<_CustomSlidingUpPanel> createState() => _CustomSlidingUpPanelState();
}

class _CustomSlidingUpPanelState extends State<_CustomSlidingUpPanel> {
  String dropdownValue = 'Sin seleccionar';
  int productQuantity = 1;
  double productTotal = 0;

  @override
  Widget build(BuildContext context) {
    final quantityController = TextEditingController();

    quantityController.text = productQuantity.toString();

    return SlidingUpPanelWidget(
      controlHeight: 0,
      anchor: 0.58,
      minimumBound: 0.42,
      upperBound: 1.72,
      panelController: widget.panelController,
      enableOnTap: false,
      onStatusChanged: (status) {
        if (SlidingUpPanelStatus.collapsed == status) {
          setState(() {
            dropdownValue = 'Sin seleccionar';
            productQuantity = 1;
            productTotal = 0;
          });
        }
      },
      child: Container(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shadows: [
            BoxShadow(
              blurRadius: 5.0,
              spreadRadius: 2.0,
              color: Colors.black12
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 35, right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Producto',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16
                ),
              ),
              DropdownButton(
                isExpanded: true,
                style: TextStyle(
                  color: Colors.orange[900],
                  fontSize: 16
                ),
                iconEnabledColor: Colors.black87,
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),  
                items: widget.productsNames.map((String product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(product)
                  );
                }).toList(),
                onChanged: (String? newValue) { 
                  _updateValues(newValue!);
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Cantidad',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16
                ),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.orange[900],
                  fontSize: 16
                ),
                onSubmitted: (value) {
                  productQuantity = int.parse(quantityController.text);
                  _updateValues(dropdownValue);
                },
                onTapOutside: (event) {
                  productQuantity = int.parse(quantityController.text);
                  _updateValues(dropdownValue);
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Total calculado',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16
                ),
              ),
              Text(
                '\$$productTotal',
                style: TextStyle(
                  color: Colors.orange[900],
                  fontSize: 16
                ),
              ),
              const SizedBox(height: 176),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.indigo[900]),
                      ),
                      onPressed: () {
                        if(dropdownValue != 'Sin seleccionar') {
                          Product product = Product(
                            category: widget.productsCategories[widget.productsNames.indexOf(dropdownValue)],
                            name: dropdownValue,
                            price: widget.productsPrices[widget.productsNames.indexOf(dropdownValue)],
                            quantity: productQuantity,
                            total: productTotal,
                            date: DateTime.now(),
                            coordinates: ''
                          );
                          
                          widget.callback(product);
                          widget.panelController.collapse();
                        }
                      },
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            side: BorderSide(color: Colors.indigo[900]!)
                          )
                        )
                      ),
                      onPressed: () {
                        widget.panelController.collapse();
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.indigo[900]
                        ),
                      )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _updateValues(product) {
    setState(() {
      dropdownValue = product;
      productTotal = double.parse((widget.productsPrices[widget.productsNames.indexOf(product)] * productQuantity).toStringAsFixed(2));
    });
  }
}