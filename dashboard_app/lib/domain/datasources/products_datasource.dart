import 'package:dashboard_app/domain/entities/product.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsSales();
}