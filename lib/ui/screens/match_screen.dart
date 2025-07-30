import 'package:fakelingo/core/dtos/swipe_dto.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:flutter/material.dart';
import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/swipe_service.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'match_detail_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final SwipeService _swipeService = SwipeService();
  final ScrollController _scrollController = ScrollController();

  List<SwipeItemModel> likedUsers = [];
  Set<String> removedUserIds = {}; // ✅ track user đã swipe
  int page = 1;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
    _scrollController.addListener(_onScroll);
  }

  Future<void> fetchMatches() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);
    try {
      final List<User> users = await _swipeService.getUnread(page, pageSize);

      setState(() {
        if (users.isEmpty) {
          hasMore = false;
        } else {
          likedUsers.addAll(users.map((u) => SwipeItemModel.fromUser(u)));
          page++;
        }
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> refreshMatches() async {
    setState(() {
      page = 1;
      likedUsers.clear();
      removedUserIds.clear();
      hasMore = true;
    });
    await fetchMatches();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      fetchMatches();
    }
  }

  /// ✅ Gọi khi swipe hoặc click xem profile
  void handleSwipe(String userId) {
    setState(() {
      removedUserIds.add(userId);
    });

    // Lazy load thêm nếu gần hết
    if (likedUsers.where((u) => !removedUserIds.contains(u.userId)).length < 3 &&
        hasMore) {
      fetchMatches();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleUsers = likedUsers
        .where((u) => !removedUserIds.contains(u.userId))
        .toList(); // ✅ lọc user đã swipe

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade400, Colors.red.shade400],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Matches',
              style: TextStyle(
                color: Color(0xFF424242),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(
                Icons.filter_list_rounded,
                color: Colors.grey.shade600,
                size: 24,
              ),
              onPressed: () {
                // TODO: Add filter functionality
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats header
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade50, Colors.red.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.pink.shade100, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${visibleUsers.length}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Người đã thích bạn',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Colors.pink.shade600,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tất cả matches',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Grid of matches
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                onRefresh: refreshMatches,
                child: GridView.builder(
                  controller: _scrollController,
                  itemCount: visibleUsers.length + (isLoading ? 1 : 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= visibleUsers.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final user = visibleUsers[index];
                    final image =
                    user.imageUrls.isNotEmpty ? user.imageUrls[0] : '';

                    return GestureDetector(
                      onTap: () {
                        handleSwipe(user.userId); // ✅ gọi khi xem chi tiết

                        final reversedUsers = visibleUsers.reversed.toList();
                        final clickedUser = visibleUsers[index];
                        final sortedList = [
                          ...reversedUsers
                              .where((u) => u.userId == clickedUser.userId),
                          ...reversedUsers
                              .where((u) => u.userId != clickedUser.userId),
                        ];

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MatchDetailScreen(
                              likedUsers: sortedList,
                              initialIndex: 0,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'match_$index',
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.3),
                                        Colors.black.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${user.name}, ${user.age}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 3,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.white70,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Cách ${user.distance ?? 0} km',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
