import 'package:dashboard_app/domain/datasources/predictions_datasource.dart';
import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/domain/repositories/predictions_repository.dart';

class PredictionsRepositoryImplementation extends PredictionsRepository {
  final PredictionsDatasource datasource;

  PredictionsRepositoryImplementation(this.datasource);

  @override
  Future<List<Prediction>> getPredictions() {
    return datasource.getPredictions();
  }
}