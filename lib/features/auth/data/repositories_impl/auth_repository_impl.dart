import 'package:dartz/dartz.dart';
import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';
import 'package:hava_kombin_app/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(identifier: identifier, password: password);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}