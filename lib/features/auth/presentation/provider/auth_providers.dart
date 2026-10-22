import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

/// 1. DioClient Provider
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// 2. Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dioClient: ref.read(dioClientProvider));
});

// 3. Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

// 4. Login UseCase Provider
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

// 5. Register UseCase Provider
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});
