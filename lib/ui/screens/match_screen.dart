import 'package:flutter/material.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('Match', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
