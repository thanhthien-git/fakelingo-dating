import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/provider/swipe_photo_provider.dart';
import 'package:fakelingo/ui/screens/other_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeCard extends StatefulWidget {
  final SwipeItemModel swipeItemModel;
  final SwipableStackController controller;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;
  final bool showArrowUpIcon;
  final bool showPrimaryDetail;
  final VoidCallback? onSwiped;

  const SwipeCard({
    Key? key,
    required this.swipeItemModel,
    required this.controller,
    required this.swipeDirectionNotifier,
    this.showArrowUpIcon = true,
    this.showPrimaryDetail = true,
    this.onSwiped,
  }) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleTap(TapUpDetails details, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final provider = Provider.of<SwipePhotoProvider>(context, listen: false);

    if (details.localPosition.dx < width / 2) {
      provider.previousPhoto();
    } else {
      provider.nextPhoto(widget.swipeItemModel.imageUrls.length);
    }
    _pageController.jumpToPage(provider.currentPhoto);
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    } else {
      return Image.asset(url, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }
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
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Consumer<SwipePhotoProvider>(
                builder: (context, provider, child) {
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => provider.setPhoto(index),
                    itemCount: model.imageUrls.length,
                    itemBuilder: (_, i) => _buildImage(model.imageUrls[i]),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  '${model.name}, ${model.age}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
