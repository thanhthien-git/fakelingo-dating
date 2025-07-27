import 'package:flutter/material.dart';
import 'package:fakelingo/core/models/feed_condition.dart';

// Thêm import này vào file chính SwiperHome
// import 'filter_settings_modal.dart';

class FilterSettingsModal extends StatefulWidget {
  final FeedCondition currentCondition;
  final Function(FeedCondition) onApplyFilters;

  const FilterSettingsModal({
    Key? key,
    required this.currentCondition,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterSettingsModalState createState() => _FilterSettingsModalState();
}

class _FilterSettingsModalState extends State<FilterSettingsModal> {
  late RangeValues _ageRange;
  late double _maxDistance;
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _ageRange = RangeValues(
      widget.currentCondition.ageMin.toDouble(),
      widget.currentCondition.ageMax.toDouble(),
    );
    _maxDistance = widget.currentCondition.maxDistance.toDouble();
    _selectedGender = widget.currentCondition.gender;
  }

  void _applyFilters() {
    final newCondition = FeedCondition(
      ageMin: _ageRange.start.round(),
      ageMax: _ageRange.end.round(),
      maxDistance: _maxDistance.round(),
      coordinates: widget.currentCondition.coordinates,
      gender: _selectedGender,
    );

    widget.onApplyFilters(newCondition);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'Bộ lọc tìm kiếm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF424242),
                  ),
                ),
                TextButton(
                  onPressed: _applyFilters,
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Age Range Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.pink, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.cake,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Độ tuổi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_ageRange.start.round()} - ${_ageRange.end.round()} tuổi',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.pink,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: Colors.pink,
                            overlayColor: Colors.pink.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 20,
                            ),
                          ),
                          child: RangeSlider(
                            values: _ageRange,
                            min: 18,
                            max: 65,
                            divisions: 47,
                            onChanged: (RangeValues values) {
                              setState(() {
                                _ageRange = values;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Distance Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.pink, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Khoảng cách tối đa',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${_maxDistance.round()} km',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.pink,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.pink,
                            inactiveTrackColor: Colors.grey.shade300,
                            thumbColor: Colors.pink,
                            overlayColor: Colors.pink.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 20,
                            ),
                          ),
                          child: Slider(
                            value: _maxDistance,
                            min: 1,
                            max: 100,
                            divisions: 99,
                            onChanged: (double value) {
                              setState(() {
                                _maxDistance = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gender Section
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.pink, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.people,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Giới tính quan tâm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF424242),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'F';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedGender == 'F'
                                        ? Colors.pink
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedGender == 'F'
                                          ? Colors.pink
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.female,
                                        color: _selectedGender == 'F'
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nữ',
                                        style: TextStyle(
                                          color: _selectedGender == 'F'
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedGender = 'M';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedGender == 'M'
                                        ? Colors.pink
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedGender == 'M'
                                          ? Colors.pink
                                          : Colors.grey.shade300,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.male,
                                        color: _selectedGender == 'M'
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nam',
                                        style: TextStyle(
                                          color: _selectedGender == 'M'
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension method để show modal
extension FilterModalExtension on BuildContext {
  void showFilterModal(
      FeedCondition currentCondition,
      Function(FeedCondition) onApplyFilters,
      ) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSettingsModal(
        currentCondition: currentCondition,
        onApplyFilters: onApplyFilters,
      ),
    );
  }
}