import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/core/services/api_service.dart';
import 'package:hava_kombin_app/features/weather/models/weather_model.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final weatherProvider = FutureProvider<WeatherModel>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getWeather();
});
