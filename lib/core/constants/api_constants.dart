class ApiConstants {
  //backend sunucu adresi (istediğiniz gibi değiştirebilirsiniz)
  static const String baseUrl = "http://192.168.1.98:3000";
  //api sunucusunda oluşturulan endpointler
  static const String login = '/giris-yap';
  static const String register = '/kayit-ol';
  static const String weatherOutfit = '/outfit/recommendation';
  static const String weather = '/hava-durumu';
  static const String wardrobe = '/gardrop';
}
