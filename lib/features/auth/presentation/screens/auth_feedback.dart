import 'package:flutter/material.dart';

class AuthFeedback {
  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'E-posta adresinizi girin.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Geçerli bir e-posta adresi girin.';
    }
    return null;
  }

  static String loginError(Object error) {
    final message = error.toString().toLowerCase();
    if (_isConnectionError(message)) {
      return 'Bağlantınızı kontrol edip tekrar deneyin.';
    }
    if (_containsAny(message, [
      '401',
      '403',
      'unauthorized',
      'invalid credential',
      'invalid password',
      'wrong password',
      'user not found',
      'şifre',
      'geçersiz giriş',
      'gecersiz giris',
      'hesap bulunamadı',
      'hesap bulunamadi',
      'kullanıcı bulunamadı',
      'kullanici bulunamadi',
    ])) {
      return 'E-posta veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.';
    }
    return 'Giriş sırasında bir sorun oluştu. Lütfen tekrar deneyin.';
  }

  static String registerError(Object error) {
    final message = error.toString().toLowerCase();
    if (_isConnectionError(message)) {
      return 'Bağlantınızı kontrol edip tekrar deneyin.';
    }
    if (_containsAny(message, [
      'already',
      'registered',
      'exists',
      'duplicate',
      'email in use',
      '409',
      'kullanımda',
      'kullanimda',
      'kullanılıyor',
      'kullaniliyor',
      'zaten kayıtlı',
      'zaten kayitli',
    ])) {
      return 'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.';
    }
    return 'Kayıt sırasında bir sorun oluştu. Lütfen tekrar deneyin.';
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFFB3261E),
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  static SnackBar successSnackBar(String message) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blue.shade700,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }

  static bool _isConnectionError(String message) {
    return _containsAny(message, [
      'socketexception',
      'connection',
      'network',
      'internet',
      'timeout',
      'zaman aşımı',
      'bağlantı',
      'baglanti',
    ]);
  }

  static bool _containsAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }
}
