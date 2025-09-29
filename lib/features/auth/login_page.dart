import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    phoneCtrl.dispose();
    passCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    final api = ApiClient.create();
    try {
      final res = await api.dio.post('/auth/login', data: {
        'phoneNumber': '+${phoneCtrl.text.trim()}',
        'password': passCtrl.text,
      });

      final data = res.data;
      final token = (data['token'] ?? data['accessToken'] ?? data['jwt'])?.toString();

      if (token == null || token.isEmpty) {
        throw Exception('Не удалось получить токен авторизации');
      }

      await Session.instance.saveToken(token);
      if (mounted) {
        context.go('/home');
      }
    } on DioException catch (e) {
      final msg = _extractError(e);
      _showSnack(msg, isError: true);
    } catch (e) {
      _showSnack('Ошибка входа: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _extractError(DioException e) {
    final d = e.response?.data;
    if (d is Map && d['message'] != null) return d['message'].toString();
    if (e.response?.statusCode == 401) return 'Неверный номер телефона или пароль';
    if (e.response?.statusCode == 404) return 'Аккаунт не найден';
    if (e.type == DioExceptionType.connectionTimeout) return 'Превышено время ожидания';
    if (e.type == DioExceptionType.receiveTimeout) return 'Сервер не отвечает';
    return 'Ошибка соединения с сервером';
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE25C5C) : const Color(0xFF6BBF59),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFAFBF8),
              const Color(0xFFF4F6F3),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Back button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => context.go('/role_selection'),
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Logo and title
                      Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7BC74D).withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.nature,
                                  size: 48,
                                  color: Color(0xFF7BC74D),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'С возвращением!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A2E25),
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Войдите, чтобы продолжить',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5A6F63),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 48),

                      // Phone input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите номер телефона';
                            }
                            if (value.length != 11) {
                              return 'Номер должен содержать 11 цифр (начиная с 7)';
                            }
                            if (!value.startsWith('7')) {
                              return 'Номер должен начинаться с 7 (формат: 7704...)';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Номер телефона',
                            hintText: '7 (___) ___-__-__',
                            prefixText: '+',
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.phone_outlined,
                                color: Color(0xFF7BC74D),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF7BC74D),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE25C5C),
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE25C5C),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Password input
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextFormField(
                          controller: passCtrl,
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите пароль';
                            }
                            if (value.length < 4) {
                              return 'Пароль должен быть не менее 4 символов';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                            prefixIcon: Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF7BC74D),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: const Color(0xFF9BA89F),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF7BC74D),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE25C5C),
                                width: 1,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFFE25C5C),
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Login button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF7BC74D),
                              Color(0xFF5CAA3D),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7BC74D).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: FilledButton(
                          onPressed: loading ? null : _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : const Text(
                            'Войти',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Forgot password
                      Center(
                        child: TextButton(
                          onPressed: () {
                            _showSnack('Функция восстановления пароля скоро будет доступна');
                          },
                          child: const Text(
                            'Забыли пароль?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7BC74D),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF9BA89F).withOpacity(0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'или',
                              style: TextStyle(
                                color: const Color(0xFF9BA89F),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF9BA89F).withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Register button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF7BC74D),
                            width: 2,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => context.go('/register'),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Создать аккаунт',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF7BC74D),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}