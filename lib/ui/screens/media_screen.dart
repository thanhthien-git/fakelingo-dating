import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<File> _mediaFiles = [];
  int _currentPage = 0;
  bool _isPicking = false;  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickImage() async {
    if (_mediaFiles.length >= 9 || _isPicking) return;
    _isPicking = true;

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _mediaFiles.add(File(pickedFile.path)));
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _replaceImageAt(int index) async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _mediaFiles[index] = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Replace image error: $e');
    } finally {
      _isPicking = false;
    }
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
      body: TabBarView(
        controller: _tabController,
        children: [_buildEditTab(), _buildPreviewTab()],
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
              // TODO: Save action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              disabledBackgroundColor: Colors.grey[800],
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

  Widget _buildEditTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  if (_mediaFiles.isEmpty && index == 0) {
                    return _buildPlaceholderTile();
                  }

                  if (index < _mediaFiles.length) {
                    final isFirstOnly = index == 0 && _mediaFiles.length == 1;
                    return _buildImageTile(index, isFirstOnly);
                  } else {
                    return GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            const SizedBox.expand(),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: _buildAddIcon(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Add a video, pic or Loop to get 4% closer to completing your profile and you may even get more Likes.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile(int index, bool isFirstOnly) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            if (isFirstOnly) _replaceImageAt(index);
          },
          child: Image.file(_mediaFiles[index], fit: BoxFit.cover),
        ),
        if (!isFirstOnly)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() => _mediaFiles.removeAt(index)),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  border: Border.all(color: Colors.white, width: 1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderTile() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/blur_background.jpg', fit: BoxFit.cover),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(onTap: _pickImage, child: _buildAddIcon()),
          ),
        ],
      ),
    );
  }

  Widget _buildAddIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFFF9800)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      padding: const EdgeInsets.all(4),
      child: const Icon(Icons.add, size: 16, color: Colors.white),
    );
  }

  Widget _buildPreviewTab() {
    final int totalPages = _mediaFiles.isEmpty ? 1 : _mediaFiles.length;

    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: totalPages,
            itemBuilder: (context, index) {
              if (_mediaFiles.isEmpty && index == 0) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/blur_background.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }

              return Center(
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_mediaFiles[index], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 24,
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
                  color: _currentPage == index ? Colors.white : Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        ),
        const Positioned(
          bottom: 40,
          left: 20,
          child: Text(
            'Luna 23',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
