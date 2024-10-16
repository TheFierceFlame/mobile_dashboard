import 'package:dashboard_app/domain/entities/sale.dart';

abstract class SalesDatasource {
  Future<List<Sale>> getDailySales();
  Future<List<Sale>> getWeeklySales();
  Future<List<Sale>> getMonthlySales();
  Future<List<Sale>> getTopSellingProducts();
  Future<List<Sale>> getTopBuyingCustomers();
}