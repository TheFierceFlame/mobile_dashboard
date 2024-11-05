import 'package:intl/intl.dart';

class JSONProduct {
  final int id;
  final String category;
  final String productName;
  final double unitaryPrice;
  final int quantity;
  final double totalAmount;
  final DateTime date;
  final String coordinates;

  JSONProduct({
    required this.id,
    required this.category,
    required this.productName,
    required this.unitaryPrice,
    required this.quantity,
    required this.totalAmount,
    required this.date,
    required this.coordinates
  });

  factory JSONProduct.fromJSON(Map<String, dynamic> json) => JSONProduct(
    id: json['id'],
    category: json['category'],
    productName: json['product_name'],
    unitaryPrice: json['unitary_price'],
    quantity: json['quantity'],
    totalAmount: json['total_amount'],
    date: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['date'].toString().replaceAll('T', ' ')),
    coordinates: json['coordinates']
  );
}