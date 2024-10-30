import 'package:dashboard_app/domain/datasources/products_datasource.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/domain/repositories/products_repository.dart';

class ProductsRepositoryImplementation extends ProductsRepository {
  final ProductsDatasource datasource;

  ProductsRepositoryImplementation(this.datasource);

  @override
  Future<List<Product>> getProductsSales() {
    return datasource.getProductsSales();
  }
}