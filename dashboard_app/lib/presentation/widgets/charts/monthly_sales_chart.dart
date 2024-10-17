import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';
import 'package:intl/intl.dart';

List<double> weeklyTotals = [];
double maxTotal = 0;

class MonthlySalesChart extends CustomLineChart {
  final List<Sale> monthlySalesData;

  const MonthlySalesChart({
    super.key,
    required this.monthlySalesData
  });

  @override
  Widget build(BuildContext context) {
    weeklyTotals = _getWeeklyTotals();
    maxTotal = _getMaxTotal();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxTotal,
              reservedSize: 30,
              getTitlesWidget: super.emptyTitleWidgets
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1.5,
              reservedSize: 30,
              getTitlesWidget: _topTitleWidgets
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 30,
              getTitlesWidget: _bottomTitleWidgets
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxTotal / 10,
              reservedSize: 50,
              getTitlesWidget: _leftTitleWidgets
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 3,
        minY: 0,
        lineBarsData: [LineChartBarData(
          spots: [
            FlSpot(0, weeklyTotals[0]),
            FlSpot(1, weeklyTotals[1]),
            FlSpot(2, weeklyTotals[2]),
            FlSpot(3, weeklyTotals[3]),
          ],
          color: Colors.indigo[900],
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        )],
      )
    );
  }

  Widget _topTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value == 1.5 ? 'Del ${DateFormat('dd/MM/yyyy').format(monthlySalesData.last.date.subtract(const Duration(days: 27)))} al ${DateFormat('dd/MM/yyyy').format(monthlySalesData.last.date)}' : '',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: mainTitleColor,
          fontSize: 16
        )
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    
    if (value == 0 || value % (maxTotal / 10) == 0) {
      text = '\$$value';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: TextStyle(
          color: mainTitleColor,
          fontSize: 12
        )
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    String text;

    switch(value) {
      case 0:
        text = 'Sem1';
        break;
      case 1:
        text = 'Sem2';
        break;
      case 2:
        text = 'Sem3';
        break;
      case 3:
        text = 'Sem4';
        break;
      default:
        text = '';
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: mainTitleColor,
          fontSize: 12,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }

  List<double> _getWeeklyTotals() {
    List<double> weeklyTotals = [0, 0, 0, 0];
    Sale lastEntry = monthlySalesData.last;
    Sale currentEntry;
    bool fromWeek;
    
    for (int iteration = 0; iteration < monthlySalesData.length; iteration++) {
      currentEntry = monthlySalesData[iteration];
      
      fromWeek = currentEntry.date.isBefore(lastEntry.date.add(const Duration(days: 1))) 
      && currentEntry.date.isAfter(lastEntry.date.subtract(const Duration(days: 7)));
      
      if (fromWeek) {weeklyTotals[3] += monthlySalesData[iteration].total; continue;}

      fromWeek = currentEntry.date.isBefore(lastEntry.date.add(const Duration(days: 6))) 
      && currentEntry.date.isAfter(lastEntry.date.subtract(const Duration(days: 14)));
      
      if (fromWeek) {weeklyTotals[2] += monthlySalesData[iteration].total; continue;}

      fromWeek = currentEntry.date.isBefore(lastEntry.date.add(const Duration(days: 13))) 
      && currentEntry.date.isAfter(lastEntry.date.subtract(const Duration(days: 21)));
      
      if (fromWeek) {weeklyTotals[1] += monthlySalesData[iteration].total; continue;}

      fromWeek = currentEntry.date.isBefore(lastEntry.date.add(const Duration(days: 20))) 
      && currentEntry.date.isAfter(lastEntry.date.subtract(const Duration(days: 28)));
      
      if (fromWeek) {weeklyTotals[0] += monthlySalesData[iteration].total; continue;}
    }

    return weeklyTotals;
  }

  double _getMaxTotal() {
    double maxValue = 0;
    
    for (int iteration = 0; iteration < weeklyTotals.length; iteration++) {
      if (weeklyTotals[iteration] > maxValue) maxValue = weeklyTotals[iteration];
    }

    return maxValue;
  }
}