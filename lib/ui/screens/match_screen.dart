import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:flutter/material.dart';
import 'match_detail_screen.dart';

class MatchScreen extends StatelessWidget {
  MatchScreen({super.key});

  final List<SwipeItemModel> mockLikedUsers = [
    SwipeItemModel(
      userId: '1',
      imageUrls: ['assets/1.png', 'assets/2.png'],
      name: 'An',
      age: 22,
      gender: 'Female',
      bio: 'Yêu đọc sách và cà phê mỗi sáng ☕',
      description: 'Người nhẹ nhàng, vui vẻ, thích đi dạo và ăn vặt.',
      lookingFor: 'Bạn trai biết quan tâm 💖',
      distance: 5,
    ),
    SwipeItemModel(
      userId: '1',
      imageUrls: ['assets/3.png', 'assets/4.png'],
      name: 'Bình',
      age: 25,
      gender: 'Male',
      bio: 'Thích du lịch bụi và chụp ảnh 📸',
      description: 'Thích khám phá, tìm người đồng hành.',
      lookingFor: 'Người thích đi đây đi đó 🗺️',
      distance: 10,
    ),
    SwipeItemModel(
      userId: '1',
      imageUrls: ['assets/5.png'],
      name: 'Chi',
      age: 23,
      gender: 'Female',
      bio: 'Mỗi ngày là một cơ hội mới 🌅',
      description: 'Nghiêm túc trong mối quan hệ.',
      lookingFor: 'Người biết lắng nghe và trưởng thành 💬',
      distance: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Match'), backgroundColor: Colors.pink),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: mockLikedUsers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final user = mockLikedUsers[index];
            final image = user.imageUrls.isNotEmpty ? user.imageUrls[0] : '';

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MatchDetailScreen(likedUsers: mockLikedUsers, initialIndex: index),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image:
                        image.startsWith('http')
                            ? NetworkImage(image)
                            : AssetImage(image) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${user.name}, ${user.age}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
