import 'dart:io';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  String name = "Luna";
  String age = "23";
  String hobbies = "Freelance, Cafe, Online games";
  String height = "";
  String purpose = "Looking for";
  String languages = "";
  String zodiac = "";
  String education = "";
  String moreText = "I love working remotely and games.";

  List<File> _mediaFiles = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _editTextField(
    String title,
    String currentValue,
    Function(String) onSave,
  ) async {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color(0xFFFF6B9D).withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFF2C2C2C)),
            decoration: InputDecoration(
              hintText: "Enter text",
              hintStyle: TextStyle(
                color: const Color(0xFF2C2C2C).withOpacity(0.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFFFF6B9D).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF6B9D),
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: const Color(0xFF2C2C2C).withOpacity(0.6),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRow(
    String title,
    String value, {
    VoidCallback? onTap,
    String? percent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFFF6B9D).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              if (percent != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB3D1).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    percent,
                    style: const TextStyle(
                      color: Color(0xFFFF6B9D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFFF6B9D).withOpacity(0.7),
              size: 16,
            ),
            title: Text(
              value.isEmpty ? "Add $title" : value,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              "Edit",
              style: TextStyle(
                color: const Color(0xFF2C2C2C).withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            onTap: onTap,
          ),
        ),
        Divider(
          color: const Color(0xFFFF6B9D).withOpacity(0.2),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildEditTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0E6), Color(0xFFFFF5F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildRow(
                  "Name",
                  name,
                  onTap: () {
                    _editTextField("Name", name, (newValue) {
                      setState(() => name = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Age",
                  age,
                  onTap: () {
                    _editTextField("Age", age, (newValue) {
                      setState(() => age = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Hobbies",
                  hobbies,
                  percent: "+6%",
                  onTap: () {
                    _editTextField("Hobbies", hobbies, (newValue) {
                      setState(() => hobbies = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Height",
                  height,
                  percent: "+3%",
                  onTap: () {
                    _editTextField("Height", height, (newValue) {
                      setState(() => height = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Dating Purpose",
                  purpose,
                  percent: "+3%",
                  onTap: () {
                    _editTextField("Dating Purpose", purpose, (newValue) {
                      setState(() => purpose = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Languages I Know",
                  languages,
                  percent: "+3%",
                  onTap: () {
                    _editTextField("Languages I Know", languages, (newValue) {
                      setState(() => languages = newValue);
                    });
                  },
                ),
                _buildRow(
                  "More About Me",
                  moreText,
                  percent: "+3%",
                  onTap: () {
                    _editTextField("More About Me", moreText, (newValue) {
                      setState(() => moreText = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Zodiac Sign",
                  zodiac,
                  onTap: () {
                    _editTextField("Zodiac Sign", zodiac, (newValue) {
                      setState(() => zodiac = newValue);
                    });
                  },
                ),
                _buildRow(
                  "Education",
                  education,
                  onTap: () {
                    _editTextField("Education", education, (newValue) {
                      setState(() => education = newValue);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    final int totalPages = _mediaFiles.isEmpty ? 1 : _mediaFiles.length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0E6), Color(0xFFFFF5F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              children: [
                // Background image / PageView
                Positioned.fill(
                  child: PageView.builder(
                    onPageChanged:
                        (index) => setState(() => _currentPage = index),
                    itemCount: totalPages,
                    itemBuilder: (context, index) {
                      if (_mediaFiles.isEmpty && index == 0) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFB3D1), Color(0xFFFF6B9D)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.photo_camera_outlined,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _mediaFiles[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFB3D1),
                                    Color(0xFFFF6B9D),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Image error',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                // Dots indicator
                if (_mediaFiles.isNotEmpty)
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalPages, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          width: 24,
                          decoration: BoxDecoration(
                            color:
                                _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),
                  ),

                // Text overlay: name, hobbies, moreText
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF2C2C2C).withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$name, $age',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (hobbies.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                hobbies.split(',').map((hobby) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFF6B9D,
                                      ).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      hobby.trim(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        const SizedBox(height: 8),
                        if (moreText.isNotEmpty)
                          Text(
                            moreText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                      ],
                    ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C2C2C)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF2C2C2C),
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFFFF6B9D),
              indicatorWeight: 3,
              labelColor: const Color(0xFFFF6B9D),
              unselectedLabelColor: const Color(0xFF2C2C2C).withOpacity(0.6),
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Edit'), Tab(text: 'Preview')],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildEditTab(), _buildPreviewTab()],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Profile saved successfully!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: const Color(0xFF00E676),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
