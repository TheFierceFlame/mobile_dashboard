import 'package:flutter_riverpod/flutter_riverpod.dart';

const baseDate = '1900-01-01T00:00:00.00';

final dailySalesFiltersProvider = StateProvider<List<String>>((ref) => [baseDate]);

final weeklySalesFiltersProvider = StateProvider<List<String>>((ref) => [baseDate]);

final monthlySalesFiltersProvider = StateProvider<List<String>>((ref) => [baseDate]);

final topSellingProductsFiltersProvider = StateProvider<List<String>>((ref) => [
  baseDate,
  baseDate
]);

final topBuyingCustomersFiltersProvider = StateProvider<List<String>>((ref) => [
  baseDate,
  baseDate
]);