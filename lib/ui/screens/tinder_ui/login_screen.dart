import 'package:fakelingo/ui/components/login_button.dart';
import 'package:fakelingo/ui/components/login_richtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/Tinder_(app)-White-Logo.wine.svg",
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),

              Column(
                children: [
                  const SizedBox(height: 10),
                  const LoginRichtext(), // Giữ nguyên nếu đã hard code bên trong
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        LoginButton(
                          iconAsset: 'assets/facebook.svg',
                          label: 'Đăng nhập với Facebook',
                          onPressed: () {
                            // TODO: Handle Facebook sign in
                          },
                        ),
                        const SizedBox(height: 15),
                        LoginButton(
                          iconAsset: 'assets/person.svg',
                          label: 'Đăng nhập với Local Account',
                          onPressed: () {
                            // TODO: Handle Local sign in
                          },
                        ),
                        const SizedBox(height: 15),
                        LoginButton(
                          iconAsset: 'assets/phone.svg',
                          label: 'Đăng nhập với Số Điện Thoại',
                          onPressed: () {
                            // TODO: Handle Phone sign in
                          },
                        ),
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
