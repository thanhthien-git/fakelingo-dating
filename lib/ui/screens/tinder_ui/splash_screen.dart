import 'dart:async';
import 'package:fakelingo/ui/screens/tinder_ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        0,
        98,
      ), // primaryColor hard-coded
      body: Center(
        child: SvgPicture.asset(
          "assets/tinder_svg.svg",
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
