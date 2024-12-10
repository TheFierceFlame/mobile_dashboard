import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/infrastructure/datasources/json_products_datasource.dart';
import 'package:dashboard_app/infrastructure/repositories/product_repository_implementation.dart';

final productsRepositoryProvider = Provider((ref) {
  return ProductsRepositoryImplementation(JSONProductsDatasource());
});