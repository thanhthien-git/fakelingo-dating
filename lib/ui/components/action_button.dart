import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class ActionTinderIconButton extends StatelessWidget {
  final IconData icon;
  final double width;
  final double height;
  final Color? activeColor;
  final Color? inActiveColor;
  final Color? activeIcon;
  final Color? inActiveIcon;
  final VoidCallback? onTap;
  final SwipeDirection? swipeDirection;
  final SwipeDirection? direction;

  const ActionTinderIconButton({
    required this.icon,
    required this.width,
    required this.height,
    this.onTap,
    required this.swipeDirection,
    this.direction,
    this.activeColor,
    this.inActiveColor,
    this.activeIcon,
    this.inActiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = swipeDirection == direction;
    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isActive
                    ? activeColor ?? Colors.green
                    : inActiveColor ?? Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 32,
              color:
                  isActive
                      ? activeIcon ?? Colors.white
                      : inActiveIcon ?? Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
