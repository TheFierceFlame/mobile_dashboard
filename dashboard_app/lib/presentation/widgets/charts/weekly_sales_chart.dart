import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';
import 'package:intl/intl.dart';

List<double> dailyTotals = [];
double maxTotal = 0;

class WeeklySalesChart extends CustomLineChart {
  final List<Sale> weeklySalesData;

  const WeeklySalesChart({
    super.key,
    required this.weeklySalesData
  });

  @override
  Widget build(BuildContext context) {
    dailyTotals = _getDailyTotals();
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
              interval: 3,
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
        maxX: 6,
        minY: 0,
        lineBarsData: [LineChartBarData(
          spots: [
            FlSpot(0, dailyTotals[0]),
            FlSpot(1, dailyTotals[1]),
            FlSpot(2, dailyTotals[2]),
            FlSpot(3, dailyTotals[3]),
            FlSpot(4, dailyTotals[4]),
            FlSpot(5, dailyTotals[5]),
            FlSpot(6, dailyTotals[6]),
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
        value == 3 ? 'Del ${DateFormat('dd/MM/yyyy').format(weeklySalesData.last.date.subtract(const Duration(days: 6)))} al ${DateFormat('dd/MM/yyyy').format(weeklySalesData.last.date)}' : '',
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
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toString(),
        textAlign: TextAlign.left,
        style: TextStyle(
          color: mainTitleColor,
          fontSize: 16
        )
      ),
    );
  }

  List<double> _getDailyTotals() {
    List<double> dailyTotals = [0, 0, 0, 0, 0, 0, 0];
    Sale firstEntry = weeklySalesData.last;
    Sale currentEntry;
    bool fromDay;
    
    for (int iteration = 0; iteration < weeklySalesData.length; iteration++) {
      currentEntry = weeklySalesData[iteration];
      
      fromDay = currentEntry.date == firstEntry.date;
      if (fromDay) {dailyTotals[6] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date)
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 2)));
      
      if (fromDay) {dailyTotals[5] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date.subtract(const Duration(days: 1))) 
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 3)));
      
      if (fromDay) {dailyTotals[4] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date.subtract(const Duration(days: 2))) 
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 4)));
      
      if (fromDay) {dailyTotals[3] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date.subtract(const Duration(days: 3))) 
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 5)));
      
      if (fromDay) {dailyTotals[2] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date.subtract(const Duration(days: 4))) 
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 6)));
      
      if (fromDay) {dailyTotals[1] += weeklySalesData[iteration].total; continue;}

      fromDay = currentEntry.date.isBefore(firstEntry.date.subtract(const Duration(days: 5))) 
      && currentEntry.date.isAfter(firstEntry.date.subtract(const Duration(days: 7)));
      
      if (fromDay) {dailyTotals[0] += weeklySalesData[iteration].total; continue;}
    }

    return dailyTotals;
  }

  double _getMaxTotal() {
    double maxValue = 0;
    
    for (int iteration = 0; iteration < dailyTotals.length; iteration++) {
      if (dailyTotals[iteration] > maxValue) maxValue = dailyTotals[iteration];
    }

    return maxValue;
  }
}