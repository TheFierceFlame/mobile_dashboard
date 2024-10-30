import 'package:dashboard_app/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProductsSales();
}