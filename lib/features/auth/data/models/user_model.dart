import 'package:hava_kombin_app/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  // JSON verisini UserModel nesnesine çevirir
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  // UserModel nesnesini JSON formatına çevirir
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
