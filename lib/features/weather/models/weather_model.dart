class WeatherModel {
  final String cityName;
  final double temp;
  final String condition;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.temp,
    required this.condition,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] ?? 'bilinmiyor',
      temp: json['temperature']?.toDouble() ?? 0.0,
      condition: json['weatherCondition'] ?? 'bilinmiyor',
      description: json['description'] ?? '',
    );
  }
}
