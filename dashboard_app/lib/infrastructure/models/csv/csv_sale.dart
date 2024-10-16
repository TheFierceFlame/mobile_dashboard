import 'package:intl/intl.dart';

class CSVSale {
  final int transactionID;
  final DateTime date;
  final String customerID;
  final String gender;
  final int age;
  final String productCategory;
  final int quantity;
  final int pricePerUnit;
  final int totalAmount;

  CSVSale({
    required this.transactionID,
    required this.date,
    required this.customerID,
    required this.gender,
    required this.age,
    required this.productCategory,
    required this.quantity,
    required this.pricePerUnit,
    required this.totalAmount
  });

  factory CSVSale.fromCSV(List<dynamic> entry) => CSVSale(
    transactionID: entry[0],
    date: DateFormat("yyyy-mm-dd").parse(entry[1] + ' 00:00:00.000'),
    customerID: entry[2],
    gender: entry[3],
    age: entry[4],
    productCategory: entry[5],
    quantity: entry[6],
    pricePerUnit: entry[7],
    totalAmount: entry[8]
  );
}