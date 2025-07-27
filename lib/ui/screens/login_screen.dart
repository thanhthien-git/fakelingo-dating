import 'package:fakelingo/core/dtos/login_dto.dart';
import 'package:fakelingo/core/provider/loading_provider.dart';
import 'package:fakelingo/core/services/auth_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLogin(BuildContext context) async {
    final loadingProvider = context.read<LoadingProvider>();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final dto = LoginDto(email: email, password: password);
    try {
      loadingProvider.setLoading(true);
      final response = await authService.login(dto);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      AnimatedToast.show(context, 'Đăng nhập thất bại');
    } finally {
      loadingProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoadingProvider>().isLoading;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFFFF5858), // Tinder red
                  Color(0xFFFFA26F), // Orange
                  Color(0xFFFD267D), // Pinkish
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.2 + 0.2 * _controller.value,
                  0.5 + 0.2 * _controller.value,
                  0.8 + 0.2 * _controller.value,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        width: 160,
                        height: 160,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Find your ride now!",
                        style: TextStyle(
                          fontFamily: 'FontBold',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      CustomInputField(
                        controller: emailController,
                        hintText: "Email",
                      ),
                      const SizedBox(height: 16),

                      CustomInputField(
                        controller: passwordController,
                        hintText: "Password",
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),

                      AnimatedButton(
                        isLoading: isLoading,
                        onPressed: isLoading ? null : () => _onLogin(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'FontBold',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Need an account? Register here',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Text("Or"),
                      const SizedBox(height: 24),
                      AnimatedButton(
                        isLoading: isLoading,
                        onPressed: null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/google_icon.svg',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontFamily: 'FontBold',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
