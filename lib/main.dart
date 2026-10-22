// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart'; // app.dart dosyasını buraya import ediyoruz

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child:
          MyApp(), // app.dart içinde tanımladığın MyApp2 sınıfını çalıştırıyoruz
    ),
  );
}
