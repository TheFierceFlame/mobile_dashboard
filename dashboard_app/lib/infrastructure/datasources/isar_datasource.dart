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

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ProductSchema],
        inspector: true,
        directory: dir.path
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> insertProductSale(Product product) async {
    final isar = await db;

    isar.writeTxnSync(() => isar.products.putSync(product));
  }

  @override
  Future<List<Product>> loadProductSales() async {
    final isar = await db;
    final count = await isar.products.count();

    if(count == 0) {
      final jsonResponse = json.decode(await rootBundle.loadString('assets/data/products/products_sales_dataset.json'));

      for (int iteration = 0; iteration < jsonResponse.length; iteration++) {
        var jsonProduct = JSONProduct.fromJSON(jsonResponse[iteration]);

        isar.writeTxnSync(() => isar.products.putSync(ProductMapper.jsonProductToEntity(jsonProduct)));
      }
    }

    return isar.products.where().findAll();
  }
}
