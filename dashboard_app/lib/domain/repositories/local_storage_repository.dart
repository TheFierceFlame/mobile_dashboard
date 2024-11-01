import 'package:dashboard_app/domain/entities/product.dart';

abstract class LocalStorageRepository {
  Future<void> insertProductSale(Product product);
  Future<List<Product>> loadProductSales();
}