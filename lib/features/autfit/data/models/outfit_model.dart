import 'package:hava_kombin_app/features/weather/models/weather_model.dart';

class OutfitModel {
  final WeatherModel weather;
  final String categoryFilter;
  final Map<String, dynamic>? gununKombini;
  final String message;

  OutfitModel({
    required this.weather,
    required this.categoryFilter,
    required this.gununKombini,
    required this.message,
  });

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      weather: WeatherModel.fromJson(json['hava_durumu'] ?? {}),
      categoryFilter: json['kategori_filtresi'] ?? '',
      gununKombini: json['gunun_kombini'] != null
          ? Map<String, dynamic>.from(json['gunun_kombini'])
          : null,
      message: json['mesaj'] ?? '',
    );
  }
}
