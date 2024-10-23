import 'package:dashboard_app/domain/datasources/sales_datasource.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/domain/repositories/sales_repository.dart';

class SalesRepositoryImplementation extends SalesRepository {
  final SalesDatasource datasource;

  SalesRepositoryImplementation(this.datasource);

  @override
  Future<List<Sale>> getDailySales(List<dynamic> salesFilters) {
    return datasource.getDailySales(salesFilters);
  }

  @override
  Future<List<Sale>> getWeeklySales(List<dynamic> salesFilters) {
    return datasource.getWeeklySales(salesFilters);
  }

  @override
  Future<List<Sale>> getMonthlySales(List<dynamic> salesFilters) {
    return datasource.getMonthlySales(salesFilters);
  }

  @override
  Future<List<Sale>> getTopSellingProducts(List<dynamic> salesFilters) {
    return datasource.getTopSellingProducts(salesFilters);
  }

  @override
  Future<List<Sale>> getTopBuyingCustomers(List<dynamic> salesFilters) {
    return datasource.getTopBuyingCustomers(salesFilters);
  }
}