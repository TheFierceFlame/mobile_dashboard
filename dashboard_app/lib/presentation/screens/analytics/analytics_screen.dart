import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/presentation/providers/analytics/sales/sales_provider.dart';
import 'package:dashboard_app/presentation/widgets/widgets.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool loading = true;
  CustomLineChart ventasDiariasChart = CustomLineChart();
  CustomLineChart ventasSemanalesChart = CustomLineChart();
  CustomLineChart ventasMensualesChart = CustomLineChart();

  @override
  void initState() {
    super.initState();
    ref.read(dailySalesProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final dailySales = ref.watch(dailySalesProvider);
    final dailySalesTitles = <SideTitleWidget Function(double value, TitleMeta meta)>[
      (double value, TitleMeta meta) {
        String text;
        switch (value.toInt()) {
          case 0:
            text = 'Lun';
            break;
          case 1:
            text = 'Mar';
            break;
          case 2:
            text = 'Mie';
            break;
          case 3:
            text = 'Jue';
            break;
          case 4:
            text = 'Vie';
            break;
          case 5:
            text = 'Sab';
            break;
          case 6:
            text = 'Dom';
            break;
          default:
            text = '';
            break;
        }

        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: mainTitleColor,
              fontSize: 16
            )
          ),
        );
      },
      (double value, TitleMeta meta) {
        String text;
        switch (value.toInt()) {
          case 1:
            text = '10K';
            break;
          case 3:
            text = '30k';
            break;
          case 5:
            text = '50k';
            break;
          default:
            text = '';
        }

        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(
            text,
            style: TextStyle(
              color: mainTitleColor,
              fontSize: 16
            )
          ),
        );
      }
    ];

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
                          'Sucursal A de la Empresa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black87,)
                      ],
                    ),
                  )
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 300),
                      child: ChartCard(
                        chartTitle: 'Ventas diarias',
                        chartTypeData: LineChart(ventasDiariasChart.lineChart(dailySales)),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 300),
                      child: ChartCard(
                        chartTitle: 'Ventas semanales',
                        chartTypeData: LineChart(ventasSemanalesChart.lineChart(dailySales)),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 300),
                      child: ChartCard(
                        chartTitle: 'Ventas mensuales',
                        chartTypeData: LineChart(ventasMensualesChart.lineChart(dailySales)),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 300),
                      child: ChartCard(
                        chartTitle: 'Productos más vendidos',
                        chartTypeData: LineChart(ventasDiariasChart.lineChart(dailySales)),
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 300),
                      child: ChartCard(
                        chartTitle: 'Clientes que más compran',
                        chartTypeData: LineChart(ventasDiariasChart.lineChart(dailySales)),
                      ),
                    ),
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

class ChartCard extends ConsumerStatefulWidget {
  final String chartTitle;
  final Widget chartTypeData;

  const ChartCard({
    super.key,
    required this.chartTitle,
    required this.chartTypeData
  });

  @override
  ChartCardState createState() => ChartCardState();
}

class ChartCardState extends ConsumerState<ChartCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              widget.chartTitle, 
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
              child: widget.chartTypeData
            ),
          ],
        ),
      ),
    );
  }
}