import 'package:dashboard_app/domain/entities/sale.dart';

abstract class SalesRepository {
  Future<List<Sale>> getDailySales(List<dynamic> salesFilters);
  Future<List<Sale>> getWeeklySales(List<dynamic> salesFilters);
  Future<List<Sale>> getMonthlySales(List<dynamic> salesFilters);
  Future<List<Sale>> getTopSellingProducts(List<dynamic> salesFilters);
  Future<List<Sale>> getTopBuyingCustomers(List<dynamic> salesFilters);
}