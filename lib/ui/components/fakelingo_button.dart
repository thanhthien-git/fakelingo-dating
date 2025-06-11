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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDD405),
          disabledBackgroundColor: const Color(0xFFFDD405),  // giữ màu vàng khi disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: isLoading ? () {} : onPressed,
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.black,
          ),
        )
            : child ?? const SizedBox.shrink(),
      ),
    );
  }
}
