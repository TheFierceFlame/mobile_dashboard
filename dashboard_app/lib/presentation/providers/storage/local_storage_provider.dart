import 'package:dashboard_app/infrastructure/datasources/clients_isar_datasource.dart';
import 'package:dashboard_app/infrastructure/datasources/products_isar_datasource.dart';
import 'package:dashboard_app/infrastructure/repositories/local_storage_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productsLocalStorageRepositoryProvider = Provider((ref) {
  return ProductsLocalStorageRepositoryImplementation(ProductsIsarDatasource());
});

final clientsLocalStorageRepositoryProvider = Provider((ref) {
  return ClientsLocalStorageRepositoryImplementation(ClientsIsarDatasource());
});