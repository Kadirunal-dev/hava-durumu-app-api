// Dio kütüphanesini projede rahatça kullanabilmek ve her seferinde tekrar base URL yazmamak için bu istemci sınıfını kuruyoruz:

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hava_kombin_app/core/constants/api_constants.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 50),
        responseType: ResponseType.json,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 1. Giriş ve kayıt gibi açık (public) endpoint'lerde token ekleme!
          if (!options.path.contains('/giris-yap') &&
              !options.path.contains('/kayit-ol')) {
            final String? token = await _secureStorage.read(key: 'jwt_token');
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );

    //ileride token bazlı authentication eklemek isterseniz buraya interceptors ekleyebilirsiniz.
    _dio.interceptors.add(LogInterceptor(request: true, error: true));
  }
  Dio get dio => _dio;
}
