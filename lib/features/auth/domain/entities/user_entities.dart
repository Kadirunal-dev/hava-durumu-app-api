import 'package:equatable/equatable.dart';

// UserEntity sınıfı, kullanıcı bilgilerini temsil eden bir varlık sınıfıdır. Bu sınıf, kullanıcıya ait id, isim ve e-posta adresi gibi bilgileri içerir. Equatable sınıfını genişleterek, nesnelerin eşitliğini kolayca kontrol edebiliriz.
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  const UserEntity({required this.id, required this.name, required this.email});

  @override
  List<Object?> get props => [id, name, email];
}
//