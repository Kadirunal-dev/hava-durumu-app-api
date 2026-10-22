import 'package:dartz/dartz.dart';
import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';
import 'package:hava_kombin_app/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failure.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String identifier,
    required String password,
  }) async {
    return await repository.login(identifier: identifier, password: password);
  }
}
