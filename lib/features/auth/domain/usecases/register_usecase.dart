import 'package:dartz/dartz.dart';
import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';
import 'package:hava_kombin_app/features/auth/domain/repositories/auth_repositories.dart';
import '../../../../core/errors/failure.dart';

// RegisterUseCase sınıfı, kullanıcı kayıt işlemlerini gerçekleştirmek için kullanılan bir iş mantığı sınıfıdır. Bu sınıf, AuthRepository arayüzünü kullanarak kullanıcı kayıt işlemlerini gerçekleştirir. call metodu, kullanıcı adı, e-posta ve şifre parametrelerini alır ve repository'nin register metodunu çağırarak kullanıcı kaydını gerçekleştirir. İşlem başarılı olursa, UserEntity nesnesi döndürülür; başarısız olursa, Failure nesnesi döndürülür.
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    return await repository.register(
      name: name,
      email: email,
      password: password,
    );
  }
}
