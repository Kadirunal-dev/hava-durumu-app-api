import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message); // Süslü parantezleri ve required'ı kaldırdık

  @override
  List<Object?> get props => [message];
}

// Sunucu tabanlı hatalar
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Yerel depolama hataları
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// İnternet bağlantısı hataları
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}
