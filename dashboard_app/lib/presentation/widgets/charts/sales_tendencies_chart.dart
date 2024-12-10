import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';

List<Color> _sectionsColors = [
  Colors.orange,
  Colors.blue,
  Colors.pink,
  Colors.brown,
  Colors.green,
  Colors.grey,
  Colors.indigo,
  Colors.yellow,
  Colors.red,
  Colors.purple,
  Colors.teal
];
double _maxTotal = 0;

class SalesTendenciesChart extends CustomLineChart {
  final List<Prediction> salesPredictionsData;

  const SalesTendenciesChart({
    super.key,
    required this.salesPredictionsData,
  });

  @override
  Widget build(BuildContext context) {
    _maxTotal = _getMaxTotal();

    return Column(
      children: [
        SizedBox(
          height: 252,
          width: 380,
          child: LineChart(
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
                    interval: 1,
                    reservedSize: 30,
                    getTitlesWidget: super.emptyTitleWidgets
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
                    interval: (_maxTotal / 10).round().toDouble(),
                    reservedSize: 60,
                    getTitlesWidget: _leftTitleWidgets
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 5,
              minY: 0,
              lineBarsData: [
                for(final (index, prediction) in salesPredictionsData.indexed)
                  LineChartBarData(
                    spots: [
                      FlSpot(0, prediction.results[0]['1'] > 0 ? prediction.results[0]['1'] : 0),
                      FlSpot(1, prediction.results[0]['2'] > 0 ? prediction.results[0]['2'] : 0),
                      FlSpot(2, prediction.results[0]['3'] > 0 ? prediction.results[0]['3'] : 0),
                      FlSpot(3, prediction.results[0]['4'] > 0 ? prediction.results[0]['4'] : 0),
                      FlSpot(4, prediction.results[0]['5'] > 0 ? prediction.results[0]['5'] : 0),
                      FlSpot(5, prediction.results[0]['6'] > 0 ? prediction.results[0]['6'] : 0),
                    ],
                    color: _sectionsColors[index],
                    isCurved: false,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  )
              ],
            )
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(10, (int index) {
            return Column(
              children: [
                _Indicator(
                  color: _sectionsColors[index],
                  text: salesPredictionsData[index].category,
                ),
                const SizedBox(height: 5)
              ],
            );
          }),
        )
      ],
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    
    if (value == 0 || value == _maxTotal || value.round() % (_maxTotal / 10).round() == 0) {
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
        text = 'Mes 1';
        break;
      case 1:
        text = 'Mes 2';
        break;
      case 2:
        text = 'Mes 3';
        break;
      case 3:
        text = 'Mes 4';
        break;
      case 4:
        text = 'Mes 5';
        break;
      case 5:
        text = 'Mes 6';
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
    
    for (var prediction in salesPredictionsData) {
      for(int iteration = 0; iteration < prediction.results[0].length; iteration++) {
        if(prediction.results[0]['${iteration + 1}'] > maxValue) maxValue = prediction.results[0]['${iteration + 1}'];
      }
    }
    print(maxValue);
    return maxValue;
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size = 16;

  const _Indicator({
    required this.color,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        )
      ],
    );
  }
}