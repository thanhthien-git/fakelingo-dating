// screens/onboarding/profile_info_step.dart
import 'package:fakelingo/core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fakelingo/ui/components/custom_input.dart';
import 'package:fakelingo/ui/components/fakelingo_button.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';

class ProfileInfoStep extends StatefulWidget {
  final Map<String, dynamic> onboardingData;
  final Function(Map<String, dynamic>) onComplete;

  const ProfileInfoStep({
    super.key,
    required this.onboardingData,
    required this.onComplete,
  });

  @override
  State<ProfileInfoStep> createState() => _ProfileInfoStepState();
}

class _ProfileInfoStepState extends State<ProfileInfoStep> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = '';
  bool _isLoading = false;
  final _userService = UserService();

  final List<String> _genders = ['M', 'F'];

  Future<void> _completeOnboarding() async {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty) {
      AnimatedToast.show(context, 'Vui lòng nhập tên của bạn');
      return;
    }

    if (ageText.isEmpty) {
      AnimatedToast.show(context, 'Vui lòng nhập tuổi của bạn');
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 18 || age > 100) {
      AnimatedToast.show(context, 'Tuổi phải từ 18 đến 100');
      return;
    }

    if (_selectedGender.isEmpty) {
      AnimatedToast.show(context, 'Vui lòng chọn giới tính');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Prepare profile data
      final profileData = {
        'name': name,
        'age': age,
        'gender': _selectedGender,
        'location': widget.onboardingData['location'],
      };

      print(_selectedGender);

      final result = await _userService.updateProfile(gender: _selectedGender, name: name, age: age, location: widget.onboardingData['location']);

      if (result['success']) {
        widget.onComplete(profileData);
      } else {
        AnimatedToast.show(context, result['message'] ?? 'Cập nhật thất bại');
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  const Center(
                    child: Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        fontFamily: 'FontBold',
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: Text(
                      'This information will help us find better matches for you',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Name input
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomInputField(
                    controller: _nameController,
                    hintText: 'Enter your name',
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Age input
                  const Text(
                    'Age',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomInputField(
                    controller: _ageController,
                    hintText: 'Enter your age',
                    keyboardType: TextInputType.number,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Gender selection
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Gender cards
                  Column(
                    children: _genders.map((gender) {
                      final isSelected = _selectedGender == gender;
                      return GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                          setState(() {
                            _selectedGender = gender == 'F' ? 'F' : 'M';
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.white.withOpacity(0.05),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                gender == 'F'
                                    ? Icons.female
                                    : gender == 'M'
                                    ? Icons.male
                                    : Icons.transgender,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                gender,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Complete button
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: AnimatedButton(
              onPressed: _isLoading ? null : _completeOnboarding,
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
                'Complete Setup',
                style: TextStyle(
                  fontFamily: 'FontBold',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}