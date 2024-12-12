import 'package:dashboard_app/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';
import 'package:dashboard_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductsAnalyticsScreen extends ConsumerStatefulWidget {
  const ProductsAnalyticsScreen({super.key});

  @override
  ProductsAnalyticsScreenState createState() => ProductsAnalyticsScreenState();
}

class ProductsAnalyticsScreenState extends ConsumerState<ProductsAnalyticsScreen> {
  final storageProductsSalesAsync = FutureProvider.autoDispose<List<Product>>((ref) async {
    final productsSalesData = await ref.read(storageProductsSalesProvider.notifier).loadSales();

    return productsSalesData;
  });
  List<String> _productsCategories = [];
  List<String> _productsNames = [];
  List<double> _productsPrices = [];

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
    setState(() {});
  }

  _showSaleModal(BuildContext context, Function callBack) {
    final quantityController = TextEditingController();
    int productQuantity = 1;
    double productTotal = 0;
    String dropdownValue = 'Sin seleccionar';

    quantityController.text = productQuantity.toString();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter bottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 450,
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
                        items: _productsNames.map((String product) {
                          return DropdownMenuItem(
                            value: product,
                            child: Text(product)
                          );
                        }).toList(),
                        onChanged: (String? product) {
                          if(product != null) {
                            bottomSheetState(() {
                              dropdownValue = product;
                              productTotal = double.parse((_productsPrices[_productsNames.indexOf(dropdownValue)] * productQuantity).toStringAsFixed(2));
                            });
                          }
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
                          bottomSheetState(() {
                            productTotal = double.parse((_productsPrices[_productsNames.indexOf(dropdownValue)] * productQuantity).toStringAsFixed(2));
                          });
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
                      const SizedBox(height: 100),
                      Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.indigo[900]),
                              ),
                              onPressed: () async {
                                if(dropdownValue != 'Sin seleccionar') {
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
                
                                  final currentLocation = await Geolocator.getCurrentPosition();
                                      
                                  Product product = Product(
                                    id: null,
                                    category: _productsCategories[_productsNames.indexOf(dropdownValue)],
                                    name: dropdownValue,
                                    price: _productsPrices[_productsNames.indexOf(dropdownValue)],
                                    quantity: productQuantity,
                                    total: productTotal,
                                    date: DateTime.now(),
                                    coordinates: '${currentLocation.latitude},${currentLocation.longitude}'
                                  );
                              
                                  callBack(product);
                                  bottomSheetState(() {
                                    Navigator.pop(context);
                                  });
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
                                Navigator.pop(context);
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsSales = ref.watch(storageProductsSalesAsync);
  
    _productsCategories = [];
    _productsNames = [];
    _productsPrices = [];

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
                context.go('/Analytics');
              },
              child: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: productsSales.when(
            data: (productsSales) {
              _getProductsData(productsSales);
              
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
                          const Text('Productos vendidos', style: TextStyle(
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
                                child: ProductsReportChart(productsSalesData: productsSales)
                              )
                            ),
                          ),
                          const Spacer(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              width: 400,
                              child: Material(
                                color: Colors.indigo[900],
                                child: InkWell(
                                  onTap: () {
                                    _showSaleModal(context, _addProductSale);
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            error: (_, __) => const CircularProgressIndicator(),
            loading: () => const CircularProgressIndicator()
          ),
          floatingActionButton: Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "FloatingActionButtonHelp",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[900],
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Uri url = Uri.parse('https://wa.me/5216679156784?text=Invitame');
                      Uri phone = Uri.parse('tel:+526679156784');
                      
                      return AlertDialog(
                        backgroundColor: Colors.orange[900],
                        content: SizedBox(
                          height: 140,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Envia un mensaje a nuestro equipo de soporte y ellos te ayudarán. Puedes elegir entre llamar o enviar un mensaje por WhatsApp al teléfono de ayuda.',
                                  maxLines: 5,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      minWidth: 60,
                                      child: const Text("Llamar"),
                                      onPressed: () async {
                                        if (!await launchUrl(phone)) {
                                          throw Exception('No se pudo abrir $url');
                                        }
                                      },
                                    ),
                                    MaterialButton(
                                      minWidth: 60,
                                      child: const Text("Mensaje"),
                                      onPressed: () async {
                                        if (!await launchUrl(url)) {
                                          throw Exception('No se pudo abrir $url');
                                        }
                                      }
                                    ),
                                    MaterialButton(
                                      minWidth: 60,
                                      child: const Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ]
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  child: const Icon(Icons.question_mark_outlined),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "FloatingActionButtonPrediction",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[900],
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const ProductsPredictionScreen();
                      })
                    );
                  },
                  child: const Icon(Icons.query_stats_outlined),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: "FloatingActionButtonTracking",
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[900],
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const ProductsTrackingScreen();
                      })
                    );
                  },
                  child: const Icon(Icons.map_outlined),
                )
              ],
            ),
          ),
        ),
      ]
    );
  }
}