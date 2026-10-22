//sunucu tabanlı hatalar için özel bir exception sınıfı oluşturuyoruz
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

//yerel depolama hataları için özel bir exception sınıfı oluşturuyoruz
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
