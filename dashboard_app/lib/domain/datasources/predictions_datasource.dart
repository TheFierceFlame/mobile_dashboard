import 'package:dashboard_app/domain/entities/prediction.dart';

abstract class PredictionsDatasource {
  Future<List<Prediction>> getPredictions();
}