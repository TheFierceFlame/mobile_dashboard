import 'dart:convert';

import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/infrastructure/mappers/json_product_mapper.dart';
import 'package:dashboard_app/infrastructure/models/json/json_product.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    
    return Isar.open(
      schemas: [ProductSchema],
      inspector: true,
      directory: dir.path
    );
  }

  @override
  Future<void> insertProductSale(Product product) async {
    final isar = await openDB();
    final newProduct = Product(
      id: isar.products.autoIncrement(),
      category: product.category,
      name: product.name,
      price: product.price,
      quantity: product.quantity,
      total: product.total,
      date: product.date,
      coordinates: product.coordinates
    );

    await isar.writeAsync((Isar isar) => isar.products.put(newProduct));
  }

  @override
  Future<void> clearProductSales() async {
    final isar = await openDB();

    await isar.writeAsync((Isar isar) async {
      isar.products.clear();
    }); 
  }

  @override
  Future<List<Product>> loadProductSales() async {
    final isar = await openDB();
    final count = isar.products.count();

    if(count == 0) {
      final jsonResponse = json.decode(await rootBundle.loadString('assets/data/products/products_sales_dataset.json'));

      for (int iteration = 0; iteration < jsonResponse.length; iteration++) {
        var jsonProduct = JSONProduct.fromJSON(jsonResponse[iteration]);

        isar.write((Isar isar) => isar.products.put(ProductMapper.jsonProductToEntity(jsonProduct)));
      }
    }

    return isar.products.where().findAll();
  }
}
