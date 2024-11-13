class JSONClient {
  final String name;
  final String phone;
  final String location;
  final List<dynamic> debts;

  JSONClient({
    required this.name,
    required this.phone,
    required this.location,
    required this.debts,
  });

  factory JSONClient.fromJSON(Map<String, dynamic> json) => JSONClient(
    name: json['name'],
    phone: json['phone'],
    location: json['location'],
    debts: json['debts'],
  );
}