import 'dart:ui';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool enabled;
  final double? width;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.enabled = true,
    this.width,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final input = ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3), // darker frosted look
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscure,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: Color(0xFFFF3A75), // Tinder-like pink
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white60,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
    );

    return widget.width != null
        ? SizedBox(width: widget.width, child: input)
        : input;
  }
}
