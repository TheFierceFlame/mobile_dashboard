import 'dart:convert';
import 'package:dashboard_app/domain/datasources/products_datasource.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/infrastructure/mappers/json_product_mapper.dart';
import 'package:dashboard_app/infrastructure/models/json/json_product.dart';
import 'package:flutter/services.dart';

class JSONProductsDatasource extends ProductsDatasource {
  @override
  Future<List<Product>> getProductsSales() async {
    final jsonResponse = jsonDecode( await rootBundle.loadString('data/products/products_sales_dataset.json'));
    final List<Product> products = [];

    for (int iteration = 0; iteration < jsonResponse.length; iteration++) {
      var jsonProduct = JSONProduct.fromJSON(jsonResponse[iteration]);
      
      products.add(ProductMapper.jsonProductToEntity(jsonProduct));
    }

    return products;
  }
}