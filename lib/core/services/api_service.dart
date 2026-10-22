// lib/core/services/api_service.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hava_kombin_app/features/autfit/data/models/outfit_model.dart';
import 'package:hava_kombin_app/features/wardrobe/model/wardrobe_model.dart';
import 'package:hava_kombin_app/features/weather/models/weather_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // Bilgisayardan test ediyorsan emülatör için:
      // Android emülatör: 'http://10.0.2.2:3000/api'
      // iOS simülatör: 'http://localhost:3000/api'
      baseUrl: 'http://192.168.1.98:3000',
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService() {
    // İstekler gönderilmeden önce araya girip token eklemek için Interceptor ekliyoruz
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Hafızadan token'ı okuyoruz
          String? token = await _secureStorage.read(key: 'jwt_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<WeatherModel> getWeather() async {
    try {
      debugPrint('Hava durumu isteği başlatılıyor...');
      final response = await _dio.get('/hava-durumu');
      debugPrint('Hava durumu yanıtı geldi: ${response.data}');
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      debugPrint('Hava durumu hatası: $e');
      rethrow;
    }
  }

  Future<OutfitModel> getDailyOutfit() async {
    try {
      final response = await _dio.get('/kombin');
      return OutfitModel.fromJson(response.data);
    } catch (e) {
      debugPrint('Günün kombini hatası: $e');
      rethrow;
    }
  }

  //ürünleri listelemedi metodu
  Future<List<WardrobeItem>> getWardrobeItems() async {
    try {
      final response = await _dio.get('/gardrop');
      debugPrint('SUNUCUDAN GELEN GARDROP VERİSİ ${response.data}');
      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      if (responseData == null) return [];
      if (responseData is List) {
        return responseData.map((e) => WardrobeItem.fromJson(e)).toList();
      }
      if (responseData is Map<String, dynamic>) {
        // 'kıyafetler' anahtarını kontrol et (Türkçe karakter güvenliği için alternatifli)
        final listKey = responseData.containsKey('kıyafetler')
            ? 'kıyafetler'
            : (responseData.containsKey('kiyafetler') ? 'kiyafetler' : 'data');

        if (responseData[listKey] is List) {
          final List list = responseData[listKey];
          return list.map((e) => WardrobeItem.fromJson(e)).toList();
        }
      }

      return [];
    } catch (e) {
      debugPrint("GARDROP YÜKLEMEE HATASI $e");
      throw Exception('Gardrop yüklenemedi: $e');
    }
  }

  //yeni kıyafet ekleme metodu
  Future<void> addWardrobeItem({
    required String name,
    required String category,
    required String weatherType,
    required String imageUrl,
  }) async {
    try {
      await _dio.post(
        '/gardrop',
        data: {
          'name': name,
          'category': category,
          'weather_type': weatherType,
          'imageUrl': imageUrl,
        },
      );
    } catch (e) {
      throw Exception('kıyafetler eklenemedi: $e');
    }
  }

  Future<void> deleteWardrobeItem(int id) async {
    try {
      await _dio.delete('/gardrop/$id');
    } catch (e) {
      throw Exception("kıyafet silinemedi : $e");
    }
  }

  Dio get dio => _dio;
  FlutterSecureStorage get secureStorage => _secureStorage;
}
