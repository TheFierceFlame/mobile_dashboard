import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/repositories/local_storage_repository.dart';


class LocalStorageRepositoryImplementation extends LocalStorageRepository {
  final LocalStorageDatasource datasource;
  LocalStorageRepositoryImplementation(this.datasource);

  @override
  Future<void> insertProductSale(Product product) {
    return datasource.insertProductSale(product);
  }

  @override
  Future<List<Product>> loadProductSales() {
    return datasource.loadProductSales();
  }
}