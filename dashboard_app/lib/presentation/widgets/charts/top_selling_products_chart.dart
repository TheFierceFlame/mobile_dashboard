import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/presentation/widgets/charts/custom_charts.dart';

List<int> productsQuantities = [];

class TopSellingProductsChart extends CustomRadarChart {
  final List<Sale> topSellingProductsData;

  const TopSellingProductsChart({
    super.key,
    required this.topSellingProductsData
  });

  @override
  Widget build(BuildContext context) {
    productsQuantities = _getProductsQuantities();

    return RadarChart(
      RadarChartData(
        dataSets: showingDataSets(),
        radarBackgroundColor: Colors.transparent,
        borderData: FlBorderData(show: false),
        radarBorderData: const BorderSide(color: Colors.transparent),
        titlePositionPercentageOffset: 0.2,
        titleTextStyle: TextStyle(color: super.mainTitleColor, fontSize: 14),
        getTitle: (index, angle) {
          switch (index) {
            case 0:
              return RadarChartTitle(
                text: 'Belleza',
                angle: angle,
              );
            case 1:
              return RadarChartTitle(
                text: 'Ropa',
                angle: angle,
              );
            case 2:
              return RadarChartTitle(
                text: 'Electrónicos',
                angle: angle);
            default:
              return const RadarChartTitle(text: '');
          }
        },
        tickCount: 1,
        ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
        tickBorderData: const BorderSide(color: Colors.transparent),
        gridBorderData: const BorderSide(color: Colors.white, width: 2),
      ),
      swapAnimationDuration: const Duration(milliseconds: 400),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      final rawDataSet = entry.value;

      return RadarDataSet(
        fillColor: rawDataSet.color.withOpacity(0.2),
        borderColor: rawDataSet.color,
        entryRadius: 2,
        dataEntries: rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    var color = Colors.orange[900]!;

    return [
      RawDataSet(
        title: 'Total',
        color: color,
        values: [
          productsQuantities[0].toDouble(),
          productsQuantities[1].toDouble(),
          productsQuantities[2].toDouble(),
        ],
      )
    ];
  }

  List<int> _getProductsQuantities() {
    List<int> productsQuantities = [0, 0, 0];

    for(var sale in topSellingProductsData) {
      switch (sale.productCategory) {
        case 'Beauty':
          productsQuantities[0]++;
          break;
        case 'Clothing':
          productsQuantities[1]++;
          break;
        case 'Electronics':
          productsQuantities[2]++;
          break;
      }
    }

    return productsQuantities;
  }
}

class RawDataSet {
  final String title;
  final Color color;
  final List<double> values;

  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });
}