class JSONProduct {
  final int id;
  final String productName;
  final double unitaryPrice;
  final int quantity;
  final double totalAmount;

  JSONProduct({
    required this.id,
    required this.productName,
    required this.unitaryPrice,
    required this.quantity,
    required this.totalAmount
  });

  factory JSONProduct.fromJSON(Map<String, dynamic> json) => JSONProduct(
    id: json['id'],
    productName: json['product_name'],
    unitaryPrice: json['unitary_price'],
    quantity: json['quantity'],
    totalAmount: json['total_amount']
  );
}