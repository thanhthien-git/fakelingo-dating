import 'package:flutter/material.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  final _formKey = GlobalKey<FormState>();

  bool _isEmailValid(String email) {
    // Regex kiểm tra email cơ bản
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

    // TODO: gọi service đăng ký ở đây

    AnimatedToast.show(context, 'Đăng ký thành công (giả lập)');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
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
                      'Prepare for a ride',
                      style: TextStyle(
                        fontFamily: 'FontNormal',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDD405),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _onRegister,
                        child: const Text(
                          'Register',
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
