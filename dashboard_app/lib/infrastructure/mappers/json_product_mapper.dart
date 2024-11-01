import 'package:dashboard_app/domain/entities/product.dart';
import 'package:dashboard_app/infrastructure/models/json/json_product.dart';

class ProductMapper {
  static Product jsonProductToEntity(JSONProduct jsonProduct) => Product(
    id: jsonProduct.id,
    category: jsonProduct.category,
    name: jsonProduct.productName,
    price: jsonProduct.unitaryPrice,
    quantity: jsonProduct.quantity,
    total: jsonProduct.totalAmount,
    date: DateTime.parse(jsonProduct.date.toString()),
    coordinates: jsonProduct.coordinates
  );
}