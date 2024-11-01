import 'package:dashboard_app/domain/datasources/local_storage_datasource.dart';
import 'package:dashboard_app/domain/entities/product.dart';
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

    return isar.products.where().findAll();
  }
}
