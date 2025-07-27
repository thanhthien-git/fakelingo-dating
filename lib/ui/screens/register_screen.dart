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

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(email);
  }

  void _onRegister() {
    final email = emailController.text.trim();
    final userName = userNameController.text.trim();
    final password = passwordController.text;
    final rePassword = rePasswordController.text;

    if (email.isEmpty || userName.isEmpty || password.isEmpty || rePassword.isEmpty) {
      AnimatedToast.show(context, 'Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (!_isEmailValid(email)) {
      AnimatedToast.show(context, 'Email không hợp lệ');
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

    AnimatedToast.show(context, 'Đăng ký thành công (giả lập)');
    Navigator.pop(context);
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
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: userNameController,
                    hintText: 'Username',
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: passwordController,
                    hintText: 'Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: rePasswordController,
                    hintText: 'Confirm Password',
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  AnimatedButton(
                    onPressed: _onRegister,
                    child: const Text(
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
                    onPressed: () => Navigator.pop(context),
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
}
