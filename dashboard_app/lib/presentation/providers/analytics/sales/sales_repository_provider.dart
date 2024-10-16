import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dashboard_app/infrastructure/datasources/csv_sales_datasource.dart';
import 'package:dashboard_app/infrastructure/repositories/sale_repository_implementation.dart';

final salesRepositoryProvider = Provider((ref) {
  return SalesRepositoryImplementation(CSVSalesDatasource());
});