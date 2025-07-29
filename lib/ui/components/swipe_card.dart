import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/ui/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeCard extends StatefulWidget {
  final SwipeItemModel swipeItemModel;
  final bool showArrowUpIcon;
  final bool showPrimaryDetail;
  final SwipableStackController controller;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;

  const SwipeCard({
    Key? key,
    required this.swipeItemModel,
    required this.controller,
    required this.swipeDirectionNotifier,
    this.showPrimaryDetail = true,
    this.showArrowUpIcon = true,
  }) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage:
          Provider.of<SwipePhotoProvider>(context, listen: false).currentPhoto,
    );
  }

  void _goToPrevious() {
    final photoProvider = Provider.of<SwipePhotoProvider>(
      context,
      listen: false,
    );
    if (photoProvider.currentPhoto > 0) {
      photoProvider.previousPhoto();
      _pageController.animateToPage(
        photoProvider.currentPhoto,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNext() {
    final photoProvider = Provider.of<SwipePhotoProvider>(
      context,
      listen: false,
    );
    if (photoProvider.currentPhoto <
        widget.swipeItemModel.imageUrls.length - 1) {
      photoProvider.nextPhoto(widget.swipeItemModel.imageUrls.length);
      _pageController.animateToPage(
        photoProvider.currentPhoto,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
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

  // Method mới để xử lý cả asset và network images
  Widget _buildImage(String imageUrl) {
    // Kiểm tra xem có phải là network URL không
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
              ),
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Không thể tải ảnh',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
      );
    } else {
      // Đây là asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Không thể tải ảnh',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.swipeItemModel;

    return GestureDetector(
      onTapUp: (details) => _handleTap(details, context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Image PageView
              Consumer<SwipePhotoProvider>(
                builder: (context, provider, child) {
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      provider.setPhoto(index);
                    },
                    itemCount: model.imageUrls.length,
                    itemBuilder: (context, index) {
                      final imageUrl = model.imageUrls[index];
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey.shade200,
                        child: _buildImage(imageUrl), // Sử dụng method mới
                      );
                    },
                  );
                },
              ),

              // Photo indicators at top
              if (model.imageUrls.length > 1)
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: Consumer<SwipePhotoProvider>(
                    builder: (context, provider, _) {
                      return Row(
                        children: List.generate(model.imageUrls.length, (
                          index,
                        ) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 3,
                              decoration: BoxDecoration(
                                color:
                                    index == provider.currentPhoto
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),

              // Bottom gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Profile info at bottom
              if (widget.showPrimaryDetail)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Name and age
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    model.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${model.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // Distance (if available)
                            if (model.distance != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Cách ${model.distance} km',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            // Bio preview
                            if (model.bio != null && model.bio!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  model.bio!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Info button
                      if (widget.showArrowUpIcon) ...[
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        OtherProfileDetailsScreen(
                                          swipeItemModel: model,
                                          controller: widget.controller,
                                          swipeDirectionNotifier:
                                              widget.swipeDirectionNotifier,
                                          showPrimaryDetail: false,
                                        ),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  const begin = Offset(0.0, 1.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  final tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  final offsetAnimation = animation.drive(
                                    tween,
                                  );

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.black87,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              // Online indicator (optional)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.green,

                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
