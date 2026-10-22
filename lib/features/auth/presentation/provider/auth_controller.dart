// Kullanıcı butonlara tıkladığında arka planda isteğin gidip gitmediğini, hata olup olmadığını veya başarı durumunu UI katmanına bildirecek olan controller sınıfımız.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hava_kombin_app/core/services/token_storage_service.dart';
import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';
import 'package:hava_kombin_app/features/weather/providers/weather_provider.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_providers.dart';

// Auth işlemlerinin durumunu tutmak için StateNotifier veya Notifier kullanabiliriz
class AuthController extends StateNotifier<AsyncValue<UserEntity?>> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStorageService _tokenStorageService;
  final Ref _ref; // Bu değişkenin tanımlı olduğundan emin ol

  AuthController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required TokenStorageService tokenStorageService,
    required Ref ref,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _tokenStorageService = tokenStorageService,
       _ref = ref,
       super(const AsyncValue.data(null));

  // --- Login ve Register fonksiyonların burada yer alıyor ---

  // 🔽 LOGOUT FONKSİYONU KESİNLİKLE BU SINIFIN İÇİNDE OLMALIDIR 🔽
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      // Doğrudan kendi yazdığın servisi ve metodunu kullanıyoruz
      await _tokenStorageService.deleteToken();

      // Uygulama genelindeki önbelleği ve state'leri temizliyoruz
      _ref.invalidate(weatherProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Giriş Yap fonksiyonu
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _loginUseCase(
      identifier: identifier,
      password: password,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }

  // Kayıt Ol fonksiyonu
  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final result = await _registerUseCase(
      name: username,
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = AsyncValue.data(user);
        return true;
      },
    );
  }
}

// Controller Provider tanımı
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserEntity?>>((ref) {
      return AuthController(
        loginUseCase: ref.watch(loginUseCaseProvider),
        registerUseCase: ref.watch(registerUseCaseProvider),
        ref: ref,
        tokenStorageService: TokenStorageService(),
      );
    });
