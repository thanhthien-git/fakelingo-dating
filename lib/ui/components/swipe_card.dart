import 'package:flutter/material.dart';

class SwipeCard extends StatefulWidget {
  final String name;
  final List<String> imageUrls;
  final int age;
  final String description;

  const SwipeCard({
    Key? key,
    required this.name,
    required this.imageUrls,
    required this.age,
    required this.description,
  }) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  late final PageController _pageController;
  int _currentPhoto = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPhoto);
  }

  void _goToPrevious() {
    if (_currentPhoto > 0) {
      setState(() {
        _currentPhoto--;
      });
      _pageController.jumpToPage(_currentPhoto);
    }
  }

  void _goToNext() {
    if (_currentPhoto < widget.imageUrls.length - 1) {
      setState(() {
        _currentPhoto++;
      });
      _pageController.jumpToPage(_currentPhoto);
    }
  }

  void _handleTap(TapUpDetails details, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < screenWidth / 2) {
      _goToPrevious();
    } else {
      _goToNext();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) => _handleTap(details, context),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    widget.imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38, // trên
                      Colors.transparent, // giữa
                      Colors.transparent, // giữa
                      Colors.black54, // dưới
                    ],
                    stops: [0.0, 0.2, 0.8, 1.0], // quy định vị trí chuyển màu
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nội dung bên trái
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.name}, ${widget.age}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        // Icon bên phải
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_upward, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                left: 16,
                right: 16,
                child: Row(
                  children: List.generate(widget.imageUrls.length, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 2,
                        decoration: BoxDecoration(
                          color:
                              index == _currentPhoto
                                  ? Colors.white
                                  : Colors.black38,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
