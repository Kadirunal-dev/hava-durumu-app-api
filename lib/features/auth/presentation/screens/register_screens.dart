// lib/features/auth/presentation/screens/register_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hava_kombin_app/features/auth/presentation/provider/auth_controller.dart';
import 'package:hava_kombin_app/features/auth/presentation/screens/auth_feedback.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) {
      _focusFirstInvalidField();
      return;
    }

    final success = await ref
        .read(authControllerProvider.notifier)
        .register(
          username: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
    if (!mounted || !success) return;

    ScaffoldMessenger.of(context).showSnackBar(
      AuthFeedback.successSnackBar('Kayıt başarılı! Giriş yapabilirsiniz.'),
    );
    Navigator.pop(context);
  }

  void _focusFirstInvalidField() {
    if (_nameController.text.trim().isEmpty) {
      _nameFocusNode.requestFocus();
    } else if (AuthFeedback.validateEmail(_emailController.text) != null) {
      _emailFocusNode.requestFocus();
    } else if (_passwordController.text.trim().isEmpty) {
      _passwordFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    ref.listen(authControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            AuthFeedback.errorSnackBar(AuthFeedback.registerError(error)),
          );
        },
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 429,
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 236, 24, 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Aramıza Katıl!',
                            style: TextStyle(
                              color: Color(0xFF0B192C),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hintText: 'Ad Soyad',
                              icon: Icons.person_outline,
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? 'Adınızı giriniz'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hintText: 'E-posta adresiniz',
                              icon: Icons.email_outlined,
                            ),
                            validator: AuthFeedback.validateEmail,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            autocorrect: true,
                            enableSuggestions: true,
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              if (!isLoading) _onRegisterPressed();
                            },
                            decoration: _inputDecoration(
                              hintText: 'Şifreniz',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.blueGrey,
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
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isLoading ? null : _onRegisterPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              minimumSize: const Size.fromHeight(52),
                            ),
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
                                    'Kayıt Ol',
                                    style: TextStyle(fontSize: 16),
                                  ),
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

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(14));

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.blue),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF3F6FA),
      isDense: true,
      constraints: const BoxConstraints(minHeight: 56),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
