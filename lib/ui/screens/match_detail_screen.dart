import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/ui/components/profile_details_card.dart';
import 'package:flutter/material.dart';

class MatchDetailScreen extends StatefulWidget {
  final SwipeItemModel user;

  const MatchDetailScreen({super.key, required this.user});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  int _currentIndex = 0;

  List<String> get imageUrls => widget.user.imageUrls;

  void _goToPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  void _goToNext() {
    if (_currentIndex < imageUrls.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = imageUrls[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.user.name}  ${widget.user.age}',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Ảnh + gesture click trái/phải
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTapDown: (details) {
                    final box = context.findRenderObject() as RenderBox;
                    final localPosition = box.globalToLocal(
                      details.globalPosition,
                    );
                    final width = box.size.width;

                    if (localPosition.dx < width / 2) {
                      _goToPrevious();
                    } else {
                      _goToNext();
                    }
                  },
                  child: Container(
                    height: 400,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        image.startsWith('http')
                            ? Image.network(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                            : Image.asset(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Indicator chấm
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imageUrls.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? Colors.pink : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            // Thông tin người dùng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: false,
                        icon: Icons.search,
                        text: 'Đang tìm kiếm',
                      ),
                      SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.sentiment_satisfied,
                        text: widget.user.lookingFor,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: false,
                        icon: Icons.contact_emergency,
                        text: 'Thông tin chính',
                      ),
                      if (widget.user.basicInfo?.distance != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.social_distance,
                          text: 'cách xa ${widget.user.basicInfo!.distance} km',
                        ),
                      ],
                      if (widget.user.basicInfo?.height != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.show_chart,
                          text: '${widget.user.basicInfo!.height} cm',
                        ),
                      ],
                      if (widget.user.basicInfo?.gender != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.person_3_rounded,
                          text: '${widget.user.basicInfo!.gender} ',
                        ),
                      ],
                      if (widget.user.basicInfo?.zodiac != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.nightlife_rounded,
                          text: '${widget.user.basicInfo!.zodiac} ',
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),

                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: false,
                        icon: Icons.contact_emergency,
                        text: 'Thông tin cơ bản',
                      ),
                      if (widget.user.bio != null) ...[
                        SizedBox(height: 12),
                        InfoRow(icon: Icons.label, text: '${widget.user.bio} '),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 28,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // TODO: mở trang chat
                      },
                      icon: const Icon(Icons.message, color: Colors.white),
                      label: const Text(
                        'Nhắn tin',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
