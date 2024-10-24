import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';
import 'package:intl/intl.dart';

List<double> _dailyTotals = [];
double _maxTotal = 0;

class WeeklySalesChart extends CustomLineChart {
  final List<Sale> weeklySalesData;
  final List<String> weeklySalesDate;

  const WeeklySalesChart({
    super.key,
    required this.weeklySalesData,
    required this.weeklySalesDate
  });

  @override
  Widget build(BuildContext context) {
    if(weeklySalesData[0].customer == '') return const Center(child: Text('Sin datos', style: TextStyle(color: Colors.black87)));

    _dailyTotals = _getDailyTotals();
    _maxTotal = _getMaxTotal();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _maxTotal,
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
              interval: _maxTotal / 10,
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
            FlSpot(0, _dailyTotals[0]),
            FlSpot(1, _dailyTotals[1]),
            FlSpot(2, _dailyTotals[2]),
            FlSpot(3, _dailyTotals[3]),
            FlSpot(4, _dailyTotals[4]),
            FlSpot(5, _dailyTotals[5]),
            FlSpot(6, _dailyTotals[6]),
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
        value == 3 ? 'Del ${
          weeklySalesDate.isEmpty
          ? DateFormat('dd/MM/yyyy').format(weeklySalesData.first.date)
          : DateFormat('dd/MM/yyyy').format(DateTime.parse(weeklySalesDate[0]))
        } al ${
          weeklySalesDate.isEmpty
          ? DateFormat('dd/MM/yyyy').format(weeklySalesData.first.date)
          : DateFormat('dd/MM/yyyy').format(DateTime.parse(weeklySalesDate[0]).add(const Duration(days: 6)))
        }' : '',
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
    
    if (value == 0 || value % (_maxTotal / 10) == 0) {
      text = '\$${value.roundToDouble()}';
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
        text = 'Día 1';
        break;
      case 1:
        text = 'Día 2';
        break;
      case 2:
        text = 'Día 3';
        break;
      case 3:
        text = 'Día 4';
        break;
      case 4:
        text = 'Día 5';
        break;
      case 5:
        text = 'Día 6';
        break;
      case 6:
        text = 'Día 7';
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
    
    for (int iteration = 0; iteration < _dailyTotals.length; iteration++) {
      if (_dailyTotals[iteration] > maxValue) maxValue = _dailyTotals[iteration];
    }

    return maxValue;
  }
}