import 'package:dashboard_app/infrastructure/datasources/json_predictions_datasource.dart';
import 'package:dashboard_app/infrastructure/repositories/predictions_repository_implementation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final predictionsRepositoryProvider = Provider((ref) {
  return PredictionsRepositoryImplementation(JSONPredictionsDatasource());
});