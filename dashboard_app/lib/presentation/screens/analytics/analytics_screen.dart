import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context) {
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
                    child: Text(
                      'Sucursal A de la Empresa',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18
                      ),
                    ),
                  )
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ChartCard(
                      chartTitle: 'Ventas diarias',
                      chartTypeData: LineChart(ventasDiariasChart.lineChart()),
                    ),
                    ChartCard(
                      chartTitle: 'Ventas semanales',
                      chartTypeData: LineChart(ventasSemanalesChart.lineChart()),
                    ),
                    ChartCard(
                      chartTitle: 'Ventas mensuales',
                      chartTypeData: LineChart(ventasMensualesChart.lineChart()),
                    ),
                    ChartCard(
                      chartTitle: 'Productos más vendidos',
                      chartTypeData: LineChart(ventasDiariasChart.lineChart()),
                    ),
                    ChartCard(
                      chartTitle: 'Clientes que más compran',
                      chartTypeData: LineChart(ventasDiariasChart.lineChart()),
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