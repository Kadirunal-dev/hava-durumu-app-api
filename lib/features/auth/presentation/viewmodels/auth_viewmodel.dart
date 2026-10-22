// lib/features/auth/presentation/viewmodels/auth_viewmodel.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hava_kombin_app/core/services/api_service.dart';

// Servisimizi global olarak sağlayan provider
final apiServiceProvider = Provider((ref) => ApiService());

// Auth state'ini ve mantığını yöneten StateNotifierProvider
final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(ref.read(apiServiceProvider));
});

class AuthViewModel extends StateNotifier<bool> {
  final ApiService _apiService;

  AuthViewModel(this._apiService) : super(false); // false = loading değil

  // KAYIT OL (Register) Metodu
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = true; // Yükleme başladı
    try {
      final response = await _apiService.dio.post(
        '/kayit-ol',
        data: {'username': username, 'email': email, 'password': password},
      );

      state = false; // Yükleme bitti
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      state = false;
      if (e is DioException) {
        debugPrint('Kayıt hatası: ${e.response?.data}');
      }
      debugPrint('Kayıt hatası: $e');
      rethrow;
    }
  }

  // GİRİŞ YAP (Login) Metodu ve JWT Saklama
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = true;
    try {
      final response = await _apiService.dio.post(
        '/giris-yap',
        data: {'identifier': identifier, 'password': password},
      );

      state = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sunucudan gelen token'ın anahtar adını kontrol et (örn: accessToken veya token)
        final token = response.data['accessToken'] ?? response.data['token'];

        if (token != null) {
          // KESİN OLMASI GEREKEN SATIR BU:
          await FlutterSecureStorage().write(key: 'jwt_token', value: token);
          return true;
        }
      }
      return false;
    } catch (e) {
      state = false;
      debugPrint('Giriş hatası: $e');
      return false;
    }
  }

  // Çıkış Yap (Logout)
  Future<void> logout() async {
    await _apiService.secureStorage.delete(key: 'jwt_token');
  }
}
