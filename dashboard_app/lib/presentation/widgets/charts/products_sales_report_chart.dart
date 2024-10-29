import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';

List<Color> _sectionsColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.yellow,
  Colors.purple
];
List<String> _customers = [];
List<double> _totalAmounts = [];

class ProductsSalesReportChart extends CustomPieChart {
  final List<Sale> topBuyingCustomersData;

  const ProductsSalesReportChart({
    super.key,
    required this.topBuyingCustomersData
  });

  @override
  Widget build(BuildContext context) {
    _customers = _getCustomers();
    _totalAmounts = _getTotalAmounts();

    return Row(
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Indicator(
                color: _sectionsColors[0],
                text: _customers[0],
              ),
              const SizedBox(height: 4),
              Indicator(
                color: _sectionsColors[1],
                text: _customers[1],
              ),
              const SizedBox(height: 4),
              Indicator(
                color: _sectionsColors[2],
                text: _customers[2],
              ),
              const SizedBox(height: 4),
              Indicator(
                color: _sectionsColors[3],
                text: _customers[3],
              ),
              const SizedBox(height: 4),
              Indicator(
                color: _sectionsColors[4],
                text: _customers[4],
              ),
            ],
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (index) {
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

  List<String> _getCustomers() {
    List<String> customers = [];

    for (var sale in topBuyingCustomersData) {
      customers.add(sale.customer);
    }

    customers = customers.toSet().toList();

    return customers;
  }

  List<double> _getTotalAmounts() {
    List<double> totalAmounts = [0, 0, 0, 0, 0, 0];

    for(var sale in topBuyingCustomersData) {
      totalAmounts[0] += sale.total;
      totalAmounts[_customers.indexOf(sale.customer) + 1] += sale.total;
    }

    return totalAmounts;
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.size = 12,
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