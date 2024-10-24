import 'package:flutter_riverpod/flutter_riverpod.dart';

final dailySalesFiltersProvider = StateProvider<List<String>>((ref) => []);
final weeklySalesFiltersProvider = StateProvider<List<String>>((ref) => []);
final monthlySalesFiltersProvider = StateProvider<List<String>>((ref) => []);
final topSellingProductsFiltersProvider = StateProvider<List<String>>((ref) => []);
final topBuyingCustomersFiltersProvider = StateProvider<List<String>>((ref) => []);