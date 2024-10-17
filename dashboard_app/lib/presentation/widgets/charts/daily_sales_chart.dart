import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';
import 'package:intl/intl.dart';

class DailySalesChart extends CustomBarChart {
  final List<Sale> dailySalesData;

  const DailySalesChart({
    super.key,
    required this.dailySalesData
  });

  @override
  Widget build(BuildContext context) {
    List<double> categoriesQuantities = [0, 0, 0];
    List<double> categoriesTotals = [0, 0, 0];
    Color? barColor = Colors.orange[900];

    for(int iteration = 0; iteration < dailySalesData.length; iteration++) {
      switch (dailySalesData[iteration].productCategory) {
        case 'Beauty':
          categoriesQuantities[0] += dailySalesData[iteration].quantity;
          categoriesTotals[0] += dailySalesData[iteration].total;
          break;
        case 'Clothing':
          categoriesQuantities[1] += dailySalesData[iteration].quantity;
          categoriesTotals[1] += dailySalesData[iteration].total;
          break;
        case 'Electronics':
          categoriesQuantities[2] += dailySalesData[iteration].quantity;
          categoriesTotals[2] += dailySalesData[iteration].total;
          break;
      }
    }
    
    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey,
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            tooltipMargin: 10,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String category;

              switch (group.x) {
                case 0:
                  category = 'Belleza';
                  break;
                case 1:
                  category = 'Ropa';
                  break;
                case 2:
                  category = 'Electrónicos';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$category\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '\$${categoriesTotals[group.x].toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: categoriesQuantities.length.toDouble(),
              getTitlesWidget: _topTitleWidgets,
              reservedSize: 30
              ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: categoriesQuantities.length.toDouble(),
              getTitlesWidget: super.emptyTitleWidgets,
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: showingGroups(categoriesQuantities, barColor),
        gridData: const FlGridData(show: false),
      )
    );
  }

  Widget _topTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value == 1 ? 'Al día ${DateFormat('dd/MM/yyyy').format(dailySalesData.first.date)}' : '',
        textAlign: TextAlign.left,
        style: TextStyle(
          color: mainTitleColor,
          fontSize: 16
        )
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    Color? barColor,
    double width = 50,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
          borderSide: const BorderSide(color: Colors.white, width: 0),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<double> quantities, Color? barColor) => List.generate(3, (index) {
    switch (index) {
      case 0:
        return makeGroupData(0, quantities[0] + 1, barColor: barColor);
      case 1:
        return makeGroupData(1, quantities[1] + 1, barColor: barColor);
      case 2:
        return makeGroupData(2, quantities[2] + 1, barColor: barColor);
      default:
        return throw Error();
    }
  });
}