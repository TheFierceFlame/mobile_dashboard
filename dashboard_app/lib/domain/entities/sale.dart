class Sale {
  final int transactionID;
  final DateTime date;
  final String customer;
  final String productCategory;
  final int quantity;
  final int unitaryPrice;
  final int total;

  Sale({
    required this.transactionID,
    required this.date,
    required this.customer,
    required this.productCategory,
    required this.quantity,
    required this.unitaryPrice,
    required this.total
  });
}