import 'package:flutter_test/flutter_test.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/auth_feedback.dart';

void main() {
  group('AuthFeedback.validateEmail', () {
    test('asks for an email when the field is empty', () {
      expect(AuthFeedback.validateEmail('  '), 'E-posta adresinizi girin.');
    });

    test('rejects an invalid email format', () {
      expect(
        AuthFeedback.validateEmail('kullanici@'),
        'Geçerli bir e-posta adresi girin.',
      );
    });

    test('accepts a valid email', () {
      expect(AuthFeedback.validateEmail('kisi@example.com'), isNull);
    });
  });

  group('AuthFeedback error messages', () {
    test('shows a credential hint for rejected login credentials', () {
      expect(
        AuthFeedback.loginError('401 Unauthorized'),
        'E-posta veya şifre hatalı. Bilgilerinizi kontrol edip tekrar deneyin.',
      );
    });

    test('shows a connection hint for network failures', () {
      expect(
        AuthFeedback.registerError('SocketException: connection failed'),
        'Bağlantınızı kontrol edip tekrar deneyin.',
      );
    });

    test('recognizes an email that is already registered', () {
      expect(
        AuthFeedback.registerError('Email already exists'),
        'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.',
      );
    });

    test('recognizes a Turkish duplicate email error', () {
      expect(
        AuthFeedback.registerError('E-posta adresi kullanımda'),
        'Bu e-posta adresi zaten kayıtlı. Giriş yapmayı deneyin.',
      );
    });

    test('does not expose unexpected server error details', () {
      expect(
        AuthFeedback.registerError('Internal Server Error: private details'),
        'Kayıt sırasında bir sorun oluştu. Lütfen tekrar deneyin.',
      );
    });
  });
}
