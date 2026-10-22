// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hava_kombin_app/features/auth/presentation/provider/auth_controller.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/register_screens.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/auth_feedback.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) {
      _focusFirstInvalidField();
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .login(
          identifier: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
    if (!mounted || !success) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(AuthFeedback.successSnackBar('Giriş başarılı!'));
    context.go('/home');
  }

  void _focusFirstInvalidField() {
    if (AuthFeedback.validateEmail(_emailController.text) != null) {
      _emailFocusNode.requestFocus();
    } else if (_passwordController.text.trim().isEmpty) {
      _passwordFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auth state'ini dinliyoruz (Hata durumunu yakalamak için)
    final authState = ref.watch(authControllerProvider);

    // Eğer state loading ise butonda loading gösterebiliriz
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthFeedback.errorSnackBar(AuthFeedback.loginError(error)),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // 1. ARKAPLAN: Üst Kısım Mavi Animasyon Alanı (Kavisli Alt Köşeler)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400, // Animasyon alanının yükseklik ayarı
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Lottie.asset(
                  'assets/raining.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
          ),

          // 2. ÖN PLAN: Form Alanı (Mavi alanın üzerine şık bir kart gibi biner)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                24.0,
                260.0,
                24.0,
                24.0,
              ), // Mavi alanın üzerine taşması için üst boşluk
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10), // Hafif derinlik gölgesi
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Hoş Geldiniz! 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Hava durumuna göre kombini keşfet.',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          const SizedBox(height: 24),

                          // E-posta Input
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              autocorrect: true,
                              enableSuggestions: true,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.blue,
                                ),
                                hintText: 'E-posta adresiniz',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              validator: AuthFeedback.validateEmail,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: TextFormField(
                              autocorrect: true,
                              enableSuggestions: true,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (!isLoading) _onLoginPressed();
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Colors.blue,
                                ),
                                hintText: 'Şifreniz',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Şifrenizi girin.'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isLoading ? null : _onLoginPressed,
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Giriş Yap',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hesabın yok mu? ',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Kayıt Ol',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
