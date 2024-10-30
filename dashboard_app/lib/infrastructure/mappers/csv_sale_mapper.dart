import 'package:dashboard_app/domain/entities/sale.dart';
import 'package:dashboard_app/infrastructure/models/csv/csv_sale.dart';

class SaleMapper {
  static Sale csvSaleToEntity(CSVSale csvSale) => Sale(
    transactionID: csvSale.transactionID,
    date: csvSale.date,
    customer: csvSale.customerID,
    productCategory: csvSale.productCategory,
    quantity: csvSale.quantity,
    unitaryPrice: csvSale.pricePerUnit,
    total: csvSale.totalAmount
  );
}