import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Color mainTitleColor = Colors.black87;
Color mainLineColor = Colors.black12;

class CustomLineChart {
  LineChartData lineChart(List<dynamic> salesData) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: mainLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: mainLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 42,
            getTitlesWidget: leftTitleWidgets
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 6,
      lineBarsData: [LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(1, 2),
          FlSpot(2, 5),
          FlSpot(3, 3.1),
          FlSpot(4, 4),
          FlSpot(5, 3),
          FlSpot(6, 4),
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
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
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
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
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
}

class CustomPieChart {

}