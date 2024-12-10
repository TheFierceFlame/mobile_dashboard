class JSONPrediction {
  final String category;
  final List<Map<String, dynamic>> results;

  JSONPrediction({
    required this.category,
    required this.results
  });

  factory JSONPrediction.fromJSON(Map<String, dynamic> json) => JSONPrediction(
    category: json.keys.first,
    results: [json[json.keys.first]!]
  );
}