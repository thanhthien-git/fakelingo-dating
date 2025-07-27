import 'package:flutter/material.dart';

class AnimatedButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final Widget? child;

  const AnimatedButton({
    Key? key,
    this.isLoading = false,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
              colors: [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
            )
                : const LinearGradient(
              colors: [Color(0xFFF93943), Color(0xFFFE6847)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
