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
      _pageController.jumpToPage(photoProvider.currentPhoto);
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
      _pageController.jumpToPage(photoProvider.currentPhoto);
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
        margin: EdgeInsets.zero,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Consumer<SwipePhotoProvider>(
                builder: (context, provider, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_pageController.hasClients) {
                      _pageController.jumpToPage(provider.currentPhoto);
                    }
                  });

                  return PageView.builder(
                    controller: _pageController,
                    itemCount: widget.swipeItemModel.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        widget.swipeItemModel.imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  );
                },
              ),
              //overlay for swipe card
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
              //Primary detail on swiper card
              if (widget.showPrimaryDetail)
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.swipeItemModel.name}, ${widget.swipeItemModel.age}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.swipeItemModel.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),
                          //Push to orther profile screen
                          if (widget.showArrowUpIcon)
                            IconButton(
                              icon: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => OtherProfileDetailsScreen(
                                          swipeItemModel: widget.swipeItemModel,
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
                                      const curve = Curves.ease;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(
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
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              //Thanh progress
              Positioned(
                top: 8,
                left: 16,
                right: 16,
                child: Consumer<SwipePhotoProvider>(
                  builder: (context, provider, _) {
                    return Row(
                      children: List.generate(
                        widget.swipeItemModel.imageUrls.length,
                        (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 2,
                              decoration: BoxDecoration(
                                color:
                                    index == provider.currentPhoto
                                        ? Colors.white
                                        : Colors.black38,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
