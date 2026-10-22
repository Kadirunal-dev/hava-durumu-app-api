import 'package:hava_kombin_app/core/errors/failure.dart';
import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';

import 'package:dartz/dartz.dart';

// AuthRepository soyut sınıfı, kullanıcı kimlik doğrulama işlemleri için gerekli olan metotları tanımlar. Bu sınıf, kullanıcı giriş ve kayıt işlemlerini gerçekleştirmek için kullanılacak olan metotları içerir. Her iki metot da Future<Either<Failure, UserEntity>> tipinde bir değer döndürür. Bu, işlemin başarılı olup olmadığını ve başarılıysa kullanıcı bilgilerini içeren bir UserEntity nesnesini döndürür. Eğer işlem başarısız olursa, bir Failure nesnesi döndürülür.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String identifier,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });
}
