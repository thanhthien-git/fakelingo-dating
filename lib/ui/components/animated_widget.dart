import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFFFF5858),
                Color(0xFFFFA26F),
                Color(0xFFFD267D),
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
          child: widget.child,
        );
      },
    );
  }
}
