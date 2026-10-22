import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routers/app_router.dart';
// import 'core/thema/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hava Kombini',
      // theme: AppTheme.LightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: ThemeMode.system, //sistem temasına göre tema seçimi yapıyoruz
      routerConfig: ref.watch(AppRouters.routerProvider),
    );
  }
}
