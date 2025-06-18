import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class CardOverlay extends StatelessWidget {
  final double swipeProgress;
  final SwipeDirection direction;

  const CardOverlay({
    Key? key,
    required this.swipeProgress,
    required this.direction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final opacity = swipeProgress.clamp(0.0, 1.0);
    late final IconData icon;
    late final Alignment alignment;
    late final Color color;
    switch (direction) {
      case SwipeDirection.right:
        icon = Icons.favorite;
        color = Colors.green;
        alignment = Alignment.topLeft;
        break;
      case SwipeDirection.left:
        icon = Icons.close;
        color = Colors.red;
        alignment = Alignment.topRight;
        break;
      // case SwipeDirection.up:
      //   icon = Icons.star;
      //   color = Colors.blue;
      //   alignment = Alignment.topCenter;
      //   break;
      default:
      return const SizedBox.shrink();
    }

    return Opacity(
      opacity: opacity,
      child: Align(
        alignment: alignment,

        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Icon(icon, size: 60, color: color),
        ),
      ),
    );
  }
}
