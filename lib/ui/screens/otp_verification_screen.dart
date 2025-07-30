// screens/otp_verification_screen.dart
import 'package:fakelingo/core/services/auth_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:fakelingo/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:fakelingo/ui/components/animated_widget.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String userName;

  const OtpVerificationScreen({
    super.key,
    required this.userName,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isLoading = false;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Auto focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1) {
      // Move to next field
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      // Move to previous field when deleting
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    final otpCode = _getOtpCode();

    if (otpCode.length != 4) {
      AnimatedToast.show(context, 'Vui lòng nhập đầy đủ mã OTP');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final userName = StorageService.getItem("userName")!;
      final result = await _authService.verifyOtp(otpCode, userName);

      if (result == 'true') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ),
          );
        }
      } else {
        AnimatedToast.show(context, 'Mã OTP không đúng');
        // Clear all fields
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      AnimatedToast.show(context, 'Có lỗi xảy ra, vui lòng thử lại');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/logo.svg',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Verify Your Account',
                        style: TextStyle(
                          fontFamily: 'FontBold',
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Enter the 4-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(4, (index) {
                          return SizedBox(
                            width: 60,
                            height: 60,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              enabled: !_isLoading,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (value) => _onDigitChanged(index, value),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 50),
                      AnimatedButton(
                        onPressed: _isLoading ? null : _verifyOtp,
                        child: _isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Verify',
                          style: TextStyle(
                            fontFamily: 'FontBold',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: _isLoading ? null : () {
                          // TODO: Implement resend OTP
                          AnimatedToast.show(context, 'Mã OTP đã được gửi lại');
                        },
                        child: Text(
                          'Didn\'t receive code? Resend',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}