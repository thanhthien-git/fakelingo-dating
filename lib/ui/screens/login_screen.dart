import 'dart:ui'; // <- Thêm cái này để dùng ImageFilter

import 'package:fakelingo/core/dtos/login_dto.dart';
import 'package:fakelingo/core/provider/loading_provider.dart';
import 'package:fakelingo/core/services/auth_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  Future<void> _onLogin(BuildContext context) async {
    final loadingProvider = context.read<LoadingProvider>();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final dto = LoginDto(email: email, password: password);
    try {
      loadingProvider.setLoading(true);
      final response = await authService.login(dto);
      print(response);
    } catch (e) {
      AnimatedToast.show(context, 'Đăng nhập thất bại');
    } finally {
      Navigator.pushReplacementNamed(context, '/home');
      loadingProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoadingProvider>().isLoading;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền
          Image.asset(
            'assets/blur_background.jpg',
            fit: BoxFit.cover,
          ),

          // Lớp làm mờ
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3), // Lớp phủ tối thêm để dễ đọc chữ
            ),
          ),

          // Nội dung chính
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                    AnimatedButton(
                      isLoading:  isLoading,
                      onPressed: isLoading ? null : () => _onLogin(context),
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
