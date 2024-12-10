import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/infrastructure/models/json/json_prediction.dart';

class PredictionMapper {
  static Prediction jsonProductToEntity(JSONPrediction jsonPrediction) => Prediction(
    category: jsonPrediction.category,
    results: jsonPrediction.results
  );
}