// screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:fakelingo/ui/components/animated_widget.dart';
import 'location_permission_step.dart';
import 'profile_info_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  Map<String, dynamic> _onboardingData = {};

  void _nextStep([Map<String, dynamic>? data]) {
    if (data != null) {
      _onboardingData.addAll(data);
    }

    if (_currentStep < 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          IconButton(
                            onPressed: _previousStep,
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          )
                        else
                          const SizedBox(width: 48),
                        Text(
                          'Step ${_currentStep + 1} of 2',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress bar
                    LinearProgressIndicator(
                      value: (_currentStep + 1) / 2,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
              // Steps content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    LocationPermissionStep(
                      onNext: _nextStep,
                    ),
                    ProfileInfoStep(
                      onboardingData: _onboardingData,
                      onComplete: (data) {
                        _onboardingData.addAll(data);
                        // Navigate to main app
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}