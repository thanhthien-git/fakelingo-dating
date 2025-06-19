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
          backgroundColor: Colors.black,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter text",
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.pink)),
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
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (percent != null)
                Text(
                  percent,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        ListTile(
          tileColor: const Color(0xFF121212),
          leading: const Icon(Icons.arrow_right, color: Colors.white),
          title: Text(
            value.isEmpty ? "Add $title" : value,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Text("Edit", style: TextStyle(color: Colors.white70)),
          onTap: onTap,
        ),
        const Divider(color: Colors.white12, height: 0),
      ],
    );
  }

  Widget _buildEditTab() {
    return ListView(
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
    );
  }

  Widget _buildPreviewTab() {
    final int totalPages = _mediaFiles.isEmpty ? 1 : _mediaFiles.length;

    return Center(
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Stack(
          children: [
            // Background image / PageView
            Positioned.fill(
              child: PageView.builder(
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  if (_mediaFiles.isEmpty && index == 0) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/blur_background.jpg',
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _mediaFiles[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            'Image error',
                            style: TextStyle(color: Colors.white),
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
                                : Colors.white24,
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
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
                                  color: const Color.fromARGB(182, 61, 60, 60),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  hobby.trim(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pink,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.white,
          tabs: const [Tab(text: 'Edit'), Tab(text: 'Preview')],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildEditTab(), _buildPreviewTab()],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved successfully")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
