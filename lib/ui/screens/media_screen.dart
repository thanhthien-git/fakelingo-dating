import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fakelingo/core/services/user_service.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<File> _mediaFiles = []; // ảnh mới
  final List<String> _photoUrls = []; // ảnh cũ
  int _currentPage = 0;
  bool _isPicking = false;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfilePhotos();
  }

  Future<void> _loadProfilePhotos() async {
    final user = await _userService.myProfile();
    setState(() {
      _photoUrls.clear();
      _photoUrls.addAll(user!.profile?.photos ?? []);
    });
  }

  Future<void> _pickImage() async {
    if ((_mediaFiles.length + _photoUrls.length) >= 9 || _isPicking) return;
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

  Future<void> _saveChanges() async {
    if (_mediaFiles.isEmpty) return;

    final result = await _userService.updatePhotos(newFiles: _mediaFiles);
    if (result['success']) {
      final List<String> uploadedUrls = List<String>.from(result['data']);
      setState(() {
        _photoUrls.addAll(uploadedUrls);
        _mediaFiles.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Media saved successfully!"),
          backgroundColor: const Color(0xFF00E676),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
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
          'Media',
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
            onPressed: _saveChanges,
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

  // --- Edit & Preview Tabs ---
  Widget _buildEditTab() {
    final totalItems = _photoUrls.length + _mediaFiles.length;

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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              // 1. Ảnh cũ
              if (index < _photoUrls.length) {
                return _buildNetworkImageTile(index);
              }
              // 2. Ảnh mới
              final newIndex = index - _photoUrls.length;
              if (newIndex < _mediaFiles.length) {
                return _buildImageTile(newIndex);
              }
              // 3. Placeholder Add
              return GestureDetector(
                onTap: _pickImage,
                child: _buildAddPlaceholder(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkImageTile(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        _photoUrls[index],
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildImageTile(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        _mediaFiles[index],
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE0E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF6B9D).withOpacity(0.3)),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Color(0xFFFF6B9D)),
      ),
    );
  }

  Widget _buildPreviewTab() {
    final allPhotos = [..._photoUrls, ..._mediaFiles.map((e) => e.path)];
    final totalPages = allPhotos.isEmpty ? 1 : allPhotos.length;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFE0E6), Color(0xFFFFF5F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: PageView.builder(
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemCount: totalPages,
        itemBuilder: (context, index) {
          final isFile = index >= _photoUrls.length;
          final imgPath = isFile
              ? _mediaFiles[index - _photoUrls.length].path
              : _photoUrls[index];

          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: isFile
                  ? Image.file(File(imgPath), fit: BoxFit.cover)
                  : Image.network(imgPath, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}
