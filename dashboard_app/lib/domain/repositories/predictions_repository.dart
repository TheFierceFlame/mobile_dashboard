import 'package:dashboard_app/domain/entities/prediction.dart';

abstract class PredictionsRepository {
  Future<List<Prediction>> getPredictions();
}