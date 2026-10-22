import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hava_kombin_app/features/autfit/presentation/screens/kombin_screen.dart';
import 'package:hava_kombin_app/features/auth/presentation/provider/auth_controller.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/login_screens.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/register_screens.dart';
import 'package:hava_kombin_app/features/home/presentation/screens/home_screen.dart';
import 'package:hava_kombin_app/features/wardrobe/screens/wardrobe_view.dart';

class AppRouters {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String outfit = '/outfit';
  static final routerProvider = Provider<GoRouter>((ref) {
    final authNotifier = ValueNotifier<AsyncValue>(const AsyncValue.loading());

    ref.listen<AsyncValue>(authControllerProvider, (previous, next) {
      authNotifier.value = next; // Oturum durumu değiştiğinde GoRouter'ı uyar
    });
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authNotifier,
      redirect: (context, state) {
        final authState = ref.read(authControllerProvider);
        final isLoggedIn = authState.hasValue && authState.value != null;
        final isLoggingIn = state.matchedLocation == '/login';

        // Kullanıcı giriş yapmamışsa ve login sayfasında değilse login'e yönlendir
        if (!isLoggedIn && !isLoggingIn) return '/login';
        // Kullanıcı giriş yapmışsa ve login sayfasındaysa ana sayfaya yönlendir
        if (isLoggedIn && isLoggingIn) return '/home';

        return null; // Yönlendirme gerekmiyorsa null dön
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) =>
              const LoginScreen(), // Login ekranını burada çağırıyoruz
        ),
        GoRoute(
          path: register,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/outfit',
          name: 'outfit',
          builder: (context, state) => const DailyOutfitView(),
        ),
        GoRoute(
          path: '/gardrop',
          name: 'gardrop',
          builder: (context, state) => const WardrobeView(),
        ),
      ],
    );
  });
}
