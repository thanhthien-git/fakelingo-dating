import 'package:fakelingo/core/dtos/login_dto.dart';
import 'package:fakelingo/core/services/auth_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  Future<void> _onLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final dto = LoginDto(email: email, password: password);
    try {
      final response = await authService.login(dto);
      print(response);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      AnimatedToast.show(context, 'Đăng nhập thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    SvgPicture.asset(
                      'assets/logo.svg',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Let's take a ride!",
                      style: TextStyle(
                        fontFamily: 'FontNormal',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Email input
                    CustomInputField(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    const SizedBox(height: 16),
                    // Password input
                    CustomInputField(
                      controller: passwordController,
                      hintText: "Password",
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFDD405),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () => _onLogin(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'FontBold',
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'No car? Take a car here!',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
