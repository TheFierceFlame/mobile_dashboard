import 'package:dashboard_app/domain/datasources/predictions_datasource.dart';
import 'package:dashboard_app/domain/entities/prediction.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/infrastructure/datasources/products_isar_datasource.dart';
import 'package:dashboard_app/infrastructure/mappers/json_prediction_mapper.dart';
import 'package:dashboard_app/infrastructure/models/json/json_prediction.dart';
import 'package:dashboard_app/infrastructure/models/json/json_product.dart';
import 'package:dio/dio.dart';

class JSONPredictionsDatasource extends PredictionsDatasource {
  final dio = Dio(BaseOptions(baseUrl: 'http://192.168.0.15:5058'));
  
  @override
  Future<List<Prediction>> getPredictions() async {
    final productsSalesData = await ProductsIsarDatasource().loadProductSales();
    List<Map<String, dynamic>> productsSalesJSON = [];

    for(Product product in productsSalesData) {
      productsSalesJSON.add(JSONProduct(
        id: product.id!,
        category: product.category,
        productName: product.name,
        unitaryPrice: product.price,
        quantity: product.quantity,
        totalAmount: product.total,
        date: product.date,
        coordinates: product.coordinates
      ).toJSON());
    }

        
    final response = await dio.post(
      '/Calculate',
      data: productsSalesJSON
    );
    final Map<String, dynamic> predictions = response.data['results'];
    List<Prediction> predictionsData = [];

    predictions.forEach((key, value) {
      predictionsData.add(PredictionMapper.jsonProductToEntity(JSONPrediction.fromJSON({key: value})));
    });

    return predictionsData;
  }
}