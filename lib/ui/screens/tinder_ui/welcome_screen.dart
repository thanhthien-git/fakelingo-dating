import 'package:fakelingo/ui/components/login_button.dart';
import 'package:fakelingo/ui/components/login_richtext.dart';
import 'package:fakelingo/ui/screens/tinder_ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 81, 69), // canvasColor
              Color.fromARGB(255, 253, 76, 88), // secondaryHeaderColor
              Color.fromARGB(255, 255, 0, 98), // primaryColor
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            stops: [0.0, 0.35, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 120),
                  SvgPicture.asset(
                    "assets/Tinder_(app)-White-Logo.wine.svg",
                    height: 80,
                    width: 80,
                  ),
                  const SizedBox(height: 35),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 35),
                  const LoginRichtext(), // Giữ nguyên nếu bên trong cũng hard code
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        LoginButton(
                          label: 'Tạo tài khoản',
                          onPressed: () {
                            // TODO: Handle Phone Number sign in
                          },
                        ),
                        const SizedBox(height: 15),
                        LoginButton(
                          label: 'Đăng nhập',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Bạn gặp sự cố khi đăng nhập?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
