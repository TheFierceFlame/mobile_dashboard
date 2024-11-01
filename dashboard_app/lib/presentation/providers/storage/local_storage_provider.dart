import 'package:dashboard_app/infrastructure/datasources/isar_datasource.dart';
import 'package:dashboard_app/infrastructure/repositories/local_storage_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImplementation(IsarDatasource());
});