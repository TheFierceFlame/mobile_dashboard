import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomBarChart extends StatelessWidget {
  final Color mainTitleColor = Colors.black87;
  final Color mainLineColor = Colors.black12;

  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(BarChartData());
  }

  Widget emptyTitleWidgets(double value, TitleMeta meta) {
   return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.transparent,
          fontSize: 16
        )
      ),
    );
  }
}

class CustomLineChart extends StatelessWidget {
  final Color mainTitleColor = Colors.black87;
  final Color mainLineColor = Colors.black12;

  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData());
  }

  Widget emptyTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.transparent,
          fontSize: 16
        )
      ),
    );
  }
}

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData());
  }
}

class CustomRadarChart extends StatelessWidget {
  final Color mainTitleColor = Colors.black87;
  final Color mainLineColor = Colors.black12;
  
  const CustomRadarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return RadarChart(RadarChartData(dataSets: []));
  }
}