import 'package:isar/isar.dart';
part 'product.g.dart';

@collection
class Product {
  Id? id;
  final String category;
  final String name;
  final double price;
  final int quantity;
  final double total;
  final DateTime date;
  final String coordinates;

  Product({
    this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.date,
    required this.coordinates
  });
}