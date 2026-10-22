class WardrobeItem {
  final int id;
  final String name;
  final String imageUrl;
  final String category; // 'ust', 'alt', 'ayakkabi' vb.
  final String weatherType; // 'soguk', 'ilik', 'sicak'

  WardrobeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.weatherType,
    required this.imageUrl,
  });

  factory WardrobeItem.fromJson(Map<String, dynamic> json) {
    return WardrobeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? "",
      weatherType:
          json['weather_type'] ??
          json['sicaklik_grubu'] ??
          json['weatherType'] ??
          "",
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
