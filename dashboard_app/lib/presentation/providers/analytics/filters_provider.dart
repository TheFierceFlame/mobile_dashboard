import 'package:flutter_riverpod/flutter_riverpod.dart';

const baseDate = '1900-01-01T00:00:00.00';

final dailySalesFiltersProvider = StateProvider<List<String>>((ref) => [baseDate]);

final weeklySalesFiltersProvider = StateProvider<List<DateTime>>((ref) => [
  DateTime.parse(baseDate),
  DateTime.parse(baseDate)
]);

final monthlySalesFiltersProvider = StateProvider<List<DateTime>>((ref) => [
  DateTime.parse(baseDate),
  DateTime.parse(baseDate)
]);

final topSellingProductsFiltersProvider = StateProvider<List<DateTime>>((ref) => [
  DateTime.parse(baseDate),
  DateTime.parse(baseDate)
]);

final topBuyingCustomersFiltersProvider = StateProvider<List<DateTime>>((ref) => [
  DateTime.parse(baseDate),
  DateTime.parse(baseDate)
]);