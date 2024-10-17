import 'package:dashboard_app/presentation/widgets/charts/top_buying_customers_chart.dart';
import 'package:dashboard_app/presentation/widgets/charts/top_selling_products_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:dashboard_app/presentation/widgets/charts/monthly_sales_chart.dart';
import 'package:dashboard_app/presentation/widgets/charts/weekly_sales_chart.dart';
import 'package:dashboard_app/presentation/providers/providers.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

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
    ref.read(dailySalesProvider.notifier).loadData();
    ref.read(weeklySalesProvider.notifier).loadData();
    ref.read(monthlySalesProvider.notifier).loadData();
    ref.read(topSellingProductsProvider.notifier).loadData();
    ref.read(topBuyingCustomersProvider.notifier).loadData();
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
    DailySalesChart ventasDiariasChart = DailySalesChart(dailySalesData: dailySales);
    WeeklySalesChart ventasSemanalesChart = WeeklySalesChart(weeklySalesData: weeklySales);
    MonthlySalesChart ventasMensualesChart = MonthlySalesChart(monthlySalesData: monthlySales);
    TopSellingProductsChart topProductosVentas = TopSellingProductsChart(topSellingProductsData: topSellingProducts);
    TopBuyingCustomersChart topClientesCompras = TopBuyingCustomersChart(topBuyingCustomersData: topBuyingCustomers);
    
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.orange[900],
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
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sucursal A de la Empresa X',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down, 
                          color: Colors.black87
                        )
                      ],
                    ),
                  )
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ChartCard(
                      chartTitle: 'Ventas diarias',
                      chartType: ventasDiariasChart,
                    ),
                    ChartCard(
                      chartTitle: 'Ventas semanales',
                      chartType: ventasSemanalesChart,
                    ),
                    ChartCard(
                      chartTitle: 'Ventas mensuales',
                      chartType: ventasMensualesChart,
                    ),
                    ChartCard(
                      chartTitle: 'Productos más vendidos',
                      chartType: topProductosVentas,
                    ),
                    ChartCard(
                      chartTitle: 'Clientes que más compran',
                      chartType: topClientesCompras,
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

  const ChartCard({
    super.key,
    required this.chartTitle,
    required this.chartType
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 300),
      child: Card(
        color: Colors.white,
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
    );
  }
}