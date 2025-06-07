import 'package:flutter/material.dart';

class AnimatedToast {
  static void show(BuildContext context, String message) {
    OverlayState? overlay;
    try {
      overlay = Overlay.of(context);
    } catch (e) {
      debugPrint('Error: No Overlay found in context: $e');
      return;
    }
    if (overlay == null) return;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        onDismissed: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;

  const _ToastWidget({required this.message, required this.onDismissed});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Slide từ trên (Offset(0, -1)) xuống vị trí chính (Offset(0, 0))
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Fade in từ 0 đến 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _startDismissTimer();
  }

  Future<void> _startDismissTimer() async {
    await Future.delayed(const Duration(milliseconds: 2000)); // 2 giây hiển thị
    if (mounted && !_isDismissed) {
      await _controller.reverse();
      if (!_isDismissed) {
        _isDismissed = true;
        widget.onDismissed();
      }
    }
  }

  @override
  void dispose() {
    _isDismissed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top, // cách trên status bar 10px
      left: 30,
      right: 30,
      child: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Text(
                  widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
