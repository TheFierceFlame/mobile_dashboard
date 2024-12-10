import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/presentation/providers/analytics/products/products_prediction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final predictionsProvider = StateNotifierProvider<_PredictionsNotifier, List<Prediction>>((ref) {
  final fetchPredictions = ref.watch(predictionsRepositoryProvider).getPredictions;

  return _PredictionsNotifier(fetchPredictions: fetchPredictions);
});

typedef _PredictionCallback = Future<List<Prediction>> Function();

class _PredictionsNotifier extends StateNotifier<List<Prediction>> {  
  bool isLoading = false;
  _PredictionCallback fetchPredictions;

  _PredictionsNotifier({
    required this.fetchPredictions,
  }): super([]);

  Future<List<Prediction>> loadPredictions() async{
    final predictions = await fetchPredictions();
    
    state = predictions;
    
    return predictions;
  }
}