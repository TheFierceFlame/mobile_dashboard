import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';
import 'package:intl/intl.dart';

List<double> _categoriesQuantities = [0, 0, 0];
List<double> _categoriesTotals = [0, 0, 0];
double _maxTotal = 0;

class DailySalesChart extends CustomBarChart {
  final List<Sale> dailySalesData;
  final List<String> dailySalesDate;

  const DailySalesChart({
    super.key,
    required this.dailySalesData,
    required this.dailySalesDate
  });

  @override
  Widget build(BuildContext context) {
    Color? barColor = Colors.orange[900];

    if(dailySalesData[0].customer == '') return const Center(child: Text('Sin datos', style: TextStyle(color: Colors.black87)));

    for(int iteration = 0; iteration < dailySalesData.length; iteration++) {
      switch (dailySalesData[iteration].productCategory) {
        case 'Beauty':
          _categoriesQuantities[0] += dailySalesData[iteration].quantity;
          _categoriesTotals[0] += dailySalesData[iteration].total;
          break;
        case 'Clothing':
          _categoriesQuantities[1] += dailySalesData[iteration].quantity;
          _categoriesTotals[1] += dailySalesData[iteration].total;
          break;
        case 'Electronics':
          _categoriesQuantities[2] += dailySalesData[iteration].quantity;
          _categoriesTotals[2] += dailySalesData[iteration].total;
          break;
      }
    }

    _maxTotal = _getMaxTotal();
    
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
                '$category\n\$${_categoriesTotals[group.x].toString()}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: _categoriesQuantities[group.x].toString(),
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
              interval: _categoriesQuantities.length.toDouble(),
              getTitlesWidget: _topTitleWidgets,
              reservedSize: 30
              ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _categoriesQuantities.length.toDouble(),
              getTitlesWidget: _bottomTitleWidgets,
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _maxTotal / 10,
              getTitlesWidget: _leftTitleWidgets,
              reservedSize: 50
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: showingGroups(_categoriesTotals, barColor),
        gridData: const FlGridData(show: false),
      )
    );
  }

  Widget _topTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value == 1 ? 'Al día ${
          dailySalesDate.isEmpty
          ? DateFormat('dd/MM/yyyy').format(dailySalesData.first.date)
          : DateFormat('dd/MM/yyyy').format(DateTime.parse(dailySalesDate[0]))
        }' : '',
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

  List<BarChartGroupData> showingGroups(List<double> totalAmounts, Color? barColor) => List.generate(3, (index) {
    switch (index) {
      case 0:
        return makeGroupData(0, totalAmounts[0], barColor: barColor);
      case 1:
        return makeGroupData(1, totalAmounts[1], barColor: barColor);
      case 2:
        return makeGroupData(2, totalAmounts[2], barColor: barColor);
      default:
        return throw Error();
    }
  });

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
        text = 'Belleza';
        break;
      case 1:
        text = 'Ropa';
        break;
      case 2:
        text = 'Electrónica';
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

  double _getMaxTotal() {
    double maxValue = 0;
    
    for (int iteration = 0; iteration < _categoriesTotals.length; iteration++) {
      if (_categoriesTotals[iteration] > maxValue) maxValue = _categoriesTotals[iteration];
    }
    
    return maxValue;
  }
}