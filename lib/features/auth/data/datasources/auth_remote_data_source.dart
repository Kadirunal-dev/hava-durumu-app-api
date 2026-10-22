import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String identifier,
    required String password,
  });
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.login,
        data: {'identifier': identifier, 'password': password},
      );

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw ServerException('Giriş yanıtı beklenen formatta değil.');
      }

      final token = responseData['accessToken'] ?? responseData['token'];
      if (token is! String || token.isEmpty) {
        throw ServerException(
          'Giriş yanıtında geçerli bir JWT token bulunamadı.',
        );
      }

      final userData = responseData['user'] ?? responseData;
      if (userData is! Map<String, dynamic>) {
        throw ServerException('Giriş yanıtında kullanıcı bilgisi bulunamadı.');
      }
      final user = UserModel.fromJson(userData);

      const secureStorage = FlutterSecureStorage();
      await secureStorage.write(key: 'jwt_token', value: token);

      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Giriş yapılamadı: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.dio.post(
        ApiConstants.register,
        data: {'username': name, 'email': email, 'password': password},
      );

      return UserModel.fromJson(response.data['user'] ?? response.data);
    } catch (e) {
      throw ServerException('Kayıt olunamadı: ${e.toString()}');
    }
  }
}
