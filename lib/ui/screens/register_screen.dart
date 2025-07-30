// screens/register_screen.dart
import 'package:fakelingo/core/services/auth_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:fakelingo/ui/screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:fakelingo/ui/components/animated_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _onRegister() async {
    final email = emailController.text.trim();
    final userName = userNameController.text.trim();
    final password = passwordController.text;
    final rePassword = rePasswordController.text;

    if (email.isEmpty || userName.isEmpty || password.isEmpty || rePassword.isEmpty) {
      AnimatedToast.show(context, 'Vui lòng điền đầy đủ thông tin');
      return;
    }

    if (password.length < 8) {
      AnimatedToast.show(context, 'Mật khẩu phải có ít nhất 8 ký tự');
      return;
    }
    if (password != rePassword) {
      AnimatedToast.show(context, 'Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.register(
        email: email,
        username: userName,
        password: password,
        rePassword: rePassword
      );

      if (result != null) {
         StorageService.saveToken(result);

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(userName: userName),
            ),
          );
        }
      } else {
        AnimatedToast.show(context, 'Đăng ký thất bại');
      }
    } catch (e) {
      print(e);
      AnimatedToast.show(context, 'Có lỗi xảy ra, vui lòng thử lại');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
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
                    'Prepare for a ride',
                    style: TextStyle(
                      fontFamily: 'FontBold',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomInputField(
                    controller: emailController,
                    hintText: 'Email',
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: userNameController,
                    hintText: 'Username',
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: rePasswordController,
                    hintText: 'Confirm Password',
                    isPassword: true,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),
                  AnimatedButton(
                    onPressed: _isLoading ? null : _onRegister,
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Register',
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
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }
}