import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool loading = true;

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
    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return const FullScreenLoader();

    final dailySales = ref.watch(dailySalesProvider);
    final weeklySales = ref.watch(weeklySalesProvider);
    final monthlySales = ref.watch(monthlySalesProvider);
    final topSellingProducts = ref.watch(topSellingProductsProvider);
    final topBuyingCustomers = ref.watch(topBuyingCustomersProvider);
    DailySalesChart ventasDiariasChart = DailySalesChart(dailySalesData: dailySales, dailySalesDate: ref.read(dailySalesFiltersProvider));
    WeeklySalesChart ventasSemanalesChart = WeeklySalesChart(weeklySalesData: weeklySales, weeklySalesDate: ref.read(weeklySalesFiltersProvider));
    MonthlySalesChart ventasMensualesChart = MonthlySalesChart(monthlySalesData: monthlySales, monthlySalesDate: ref.read(monthlySalesFiltersProvider));
    TopSellingProductsChart topProductosVentas = TopSellingProductsChart(topSellingProductsData: topSellingProducts);
    TopBuyingCustomersChart topClientesCompras = TopBuyingCustomersChart(topBuyingCustomersData: topBuyingCustomers);
    final List<String> analyticsScreens = [
      'AnalyticsScreen',
      'ProductsAnalyticsScreen',
      'DebtorsAnalyticsScreen'
    ];
    String dropdownValue = 'AnalyticsScreen';
    
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Estadísticas y Seguimiento',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
        )
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DropdownButton(
                            isExpanded: true,
                            focusColor: Colors.white,
                            dropdownColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 18
                            ),
                            iconEnabledColor: Colors.black87,
                            value: dropdownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),  
                            items: analyticsScreens.map((String product) {
                              return DropdownMenuItem(
                                value: product,
                                child: Text(product)
                              );
                            }).toList(),
                            onChanged: (String? newValue) { 
                              switch (newValue) {
                                case "AnalyticsScreen":
                                  break;
                                case "ProductsAnalyticsScreen":
                                  context.go('/ProductsAnalytics');
                          
                                  break;
                                case "DebtorsAnalyticsScreen":
                                  context.go('/DebtorsAnalytics');
                          
                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ChartCard(
                      chartTitle: 'Ventas diarias',
                      chartType: ventasDiariasChart,
                      chartFilters: const DailySalesFilters()
                    ),
                    ChartCard(
                      chartTitle: 'Ventas semanales',
                      chartType: ventasSemanalesChart,
                      chartFilters: const WeeklySalesFilters(),
                    ),
                    ChartCard(
                      chartTitle: 'Ventas mensuales',
                      chartType: ventasMensualesChart,
                      chartFilters: const MonthlySalesFilters(),
                    ),
                    ChartCard(
                      chartTitle: 'Productos más vendidos',
                      chartType: topProductosVentas,
                      chartFilters: const DailySalesFilters(),
                    ),
                    ChartCard(
                      chartTitle: 'Clientes que más compran',
                      chartType: topClientesCompras,
                      chartFilters: const DailySalesFilters(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  final String chartTitle;
  final Widget chartType;
  final Widget chartFilters;

  const ChartCard({
    super.key,
    required this.chartTitle,
    required this.chartType,
    required this.chartFilters
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Slidable(
          endActionPane: ActionPane(
            extentRatio: 0.92,
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                label: 'Filtrar',
                backgroundColor: Colors.indigo[900]!,
                foregroundColor: Colors.white,
                icon: Icons.filter_list,
                borderRadius: BorderRadius.circular(16),
                onPressed: (_) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return chartFilters;
                  }
                )
              )
            ],
          ),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Text(
                    chartTitle, 
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18
                    )
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 252,
                    width: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: chartType
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}