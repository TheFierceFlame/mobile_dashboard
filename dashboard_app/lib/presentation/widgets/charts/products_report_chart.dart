import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/product.dart';
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
List<String> _topProducts = [];
List<double> _totalAmounts = [];

class ProductsReportChart extends CustomPieChart {
  final List<Product> productsSalesData;

  const ProductsReportChart({
    super.key,
    required this.productsSalesData
  });

  @override
  Widget build(BuildContext context) {
    _topProducts = [];
    _totalAmounts = List.filled(11, 0);

    _getTopProducts();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: showingSections(),
              )
            ),
          ),
        ),
        Column(
          children: List.generate(10, (int index) {
            return Column(
              children: [
                _Indicator(
                  color: _sectionsColors[index],
                  text: '${_topProducts[index]} \$${_totalAmounts[index + 1]}',
                ),
                const SizedBox(height: 10)
              ],
            );
          }),
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(10, (index) {
      const fontSize = 16.0;
      const radius = 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      double value = (_totalAmounts[index + 1] / _totalAmounts[0]) * 100;

      return PieChartSectionData(
        color: _sectionsColors[index],
        value: value,
        title: '${value.round()}%',
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }

  _getTopProducts() {
    List<Product> provisionalData = List.from(productsSalesData);
    List<Map<String, dynamic>> repeatedElements = [];
    int cicle = 0;
    List<String> topProducts = [];

    while (cicle < provisionalData.length) {
      Product element = provisionalData[cicle];
      double amount = 0;
      
      for (int repetition = 0; repetition < provisionalData.length; repetition++) {
        if (repetition == cicle || element.name == provisionalData[repetition].name) {
          amount += provisionalData[repetition].total;
        }
      }
      
      provisionalData.removeWhere((product) => product.name == element.name);
      repeatedElements.add({element.name : double.parse(amount.toStringAsFixed(2))});
    }
    
    repeatedElements.sort((b, a) => (a[a.keys.toList()[0]]).compareTo(b[b.keys.toList()[0]]));
    
    for(int iteration = 0; iteration < 10; iteration++) {
      for(var product in productsSalesData.where((element) => element.name == repeatedElements[iteration].keys.toList()[0])) {
        topProducts.add(product.name);
        _totalAmounts[iteration + 1] += product.total;
      }

      _totalAmounts[0] += _totalAmounts[iteration + 1];
    }

    _topProducts = topProducts.toSet().toList();
    _totalAmounts[0] = double.parse(_totalAmounts[0].toStringAsFixed(2));
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