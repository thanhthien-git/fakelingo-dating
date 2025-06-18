import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:swipable_stack/swipable_stack.dart';

class BottomButtonsRow extends StatelessWidget {
  final void Function(SwipeDirection direction) onSwipe;
  final VoidCallback onRewindTap;
  final bool canRewind;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;

  const BottomButtonsRow({
    Key? key,
    required this.onSwipe,
    required this.onRewindTap,
    required this.canRewind,
    required this.swipeDirectionNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SwipeDirection?>(
      valueListenable: swipeDirectionNotifier,
      builder: (context, direction, _) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSlot(
                  show: direction == null,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/back.svg',
                      width: 48,
                      height: 48,
                      color: canRewind ? Colors.orange : Colors.orange,
                    ),
                    onPressed: canRewind ? onRewindTap : null,
                  ),
                ),
                _buildSlot(
                  show: direction == null || direction == SwipeDirection.left,
                  child: _ActionIconButton(
                    asset: 'assets/x_circle.svg',
                    width: 64,
                    height: 64,
                    color:
                        direction == SwipeDirection.left
                            ? Colors.black
                            : Colors.red,
                    onTap: () => onSwipe(SwipeDirection.left),
                  ),
                ),
                _buildSlot(
                  show: direction == null || direction == SwipeDirection.up,
                  child: _ActionIconButton(
                    asset: 'assets/star_circle.svg',
                    width: 48,
                    height: 48,
                    color: direction == SwipeDirection.up ? Colors.blue : null,
                    onTap: () => onSwipe(SwipeDirection.up),
                  ),
                ),
                _buildSlot(
                  show: direction == null || direction == SwipeDirection.right,
                  child: _ActionIconButton(
                    width: 64,
                    height: 64,
                    asset: 'assets/heart_circle.svg',
                    color:
                        direction == SwipeDirection.right ? Colors.green : null,
                    onTap:
                        () async => {
                          await Future.delayed(Duration(seconds: 2)),
                          onSwipe(SwipeDirection.right),
                        },
                  ),
                ),
                _buildSlot(
                  show: direction == null,
                  child: _ActionIconButton(
                    width: 48,
                    height: 48,
                    asset: 'assets/thunder_circle.svg',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlot({required bool show, required Widget child}) {
    return show ? child : SizedBox(width: 50, height: 48);
  }
}

class _ActionIconButton extends StatelessWidget {
  final String asset;
  final double width;
  final double height;
  final Color? color;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.asset,
    required this.width,
    required this.height,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(asset, width: width, height: height, color: color),
      onPressed: onTap,
    );
  }
}
