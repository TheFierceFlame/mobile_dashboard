import 'package:dashboard_app/domain/datasources/sales_datasource.dart';
import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/domain/repositories/sales_repository.dart';

class SalesRepositoryImplementation extends SalesRepository {
  final SalesDatasource datasource;

  SalesRepositoryImplementation(this.datasource);

  @override
  Future<List<Sale>> getDailySales() {
    return datasource.getDailySales();
  }

  @override
  Future<List<Sale>> getWeeklySales() {
    return datasource.getDailySales();
  }

  @override
  Future<List<Sale>> getMonthlySales() {
    return datasource.getDailySales();
  }

  @override
  Future<List<Sale>> getTopSellingProducts() {
    return datasource.getDailySales();
  }

  @override
  Future<List<Sale>> getTopBuyingCustomers() {
    return datasource.getDailySales();
  }
}