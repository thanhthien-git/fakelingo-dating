import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:flutter/material.dart';
import 'match_detail_screen.dart'; // Đảm bảo bạn đã tạo file này

class MatchScreen extends StatelessWidget {
  MatchScreen({super.key});

  final List<SwipeItemModel> mockLikedUsers = [
    SwipeItemModel(
      imageUrls: ['https://i.pravatar.cc/300?img=1'],
      name: 'An',
      age: 22,
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Love traveling and exploring new places.',
      basicInfo: BasicInfoModel(
        distance: 2,
        height: 165,
        gender: 'Female',
        zodiac: 'Bạch Dương',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Bình',
      age: 24,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Enjoys hiking and outdoor adventures.',
      basicInfo: BasicInfoModel(
        distance: 3,
        height: 175,
        gender: 'Male',
        zodiac: 'Kim Ngưu',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Châu',
      age: 21,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Passionate about music and art.',
      basicInfo: BasicInfoModel(
        distance: 1,
        height: 160,
        gender: 'Female',
        zodiac: 'Thiên Bình',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Dương',
      age: 23,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Foodie and fitness enthusiast.',
      basicInfo: BasicInfoModel(
        distance: 4,
        height: 170,
        gender: 'Male',
        zodiac: 'Song Ngư',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['https://i.pravatar.cc/300?img=1'],
      name: 'An',
      age: 22,
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Love traveling and exploring new places.',
      basicInfo: BasicInfoModel(
        distance: 2,
        height: 165,
        gender: 'Female',
        zodiac: 'Bạch Dương',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Bình',
      age: 24,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Enjoys hiking and outdoor adventures.',
      basicInfo: BasicInfoModel(
        distance: 3,
        height: 175,
        gender: 'Male',
        zodiac: 'Kim Ngưu',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Châu',
      age: 21,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Passionate about music and art.',
      basicInfo: BasicInfoModel(
        distance: 1,
        height: 160,
        gender: 'Female',
        zodiac: 'Thiên Bình',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Dương',
      age: 23,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Foodie and fitness enthusiast.',
      basicInfo: BasicInfoModel(
        distance: 4,
        height: 170,
        gender: 'Male',
        zodiac: 'Song Ngư',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['https://i.pravatar.cc/300?img=1'],
      name: 'An',
      age: 22,
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Love traveling and exploring new places.',
      basicInfo: BasicInfoModel(
        distance: 2,
        height: 165,
        gender: 'Female',
        zodiac: 'Bạch Dương',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Bình',
      age: 24,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Enjoys hiking and outdoor adventures.',
      basicInfo: BasicInfoModel(
        distance: 3,
        height: 175,
        gender: 'Male',
        zodiac: 'Kim Ngưu',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Châu',
      age: 21,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Passionate about music and art.',
      basicInfo: BasicInfoModel(
        distance: 1,
        height: 160,
        gender: 'Female',
        zodiac: 'Thiên Bình',
      ),
    ),
    SwipeItemModel(
      imageUrls: ['assets/amba.jpg', 'assets/meomeo.jpg', 'assets/1.png'],
      name: 'Dương',
      age: 23,
      bio:
          "Sinh viên năm cuối ngành thiết kế, thích vẽ tranh và đi cà phê cuối tuần.",
      lookingFor: "Một người cùng sở thích du lịch và đọc sách",
      description: 'Foodie and fitness enthusiast.',
      basicInfo: BasicInfoModel(
        distance: 4,
        height: 170,
        gender: 'Male',
        zodiac: 'Song Ngư',
      ),
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
                    builder: (_) => MatchDetailScreen(user: user),
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
