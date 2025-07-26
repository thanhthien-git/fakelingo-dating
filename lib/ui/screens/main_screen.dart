import 'package:fakelingo/core/services/socket_service.dart';
import 'package:fakelingo/core/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fakelingo/ui/screens/home.dart';
import 'package:fakelingo/ui/screens/match_screen.dart';
import 'package:fakelingo/ui/screens/message_screen.dart';
import 'package:fakelingo/ui/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const MatchScreen(),
    MessageScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final SocketService socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    final userId = await StorageService.getItem('user_id');
    if (userId != null) {
      socketService.initSocket(userId);
    } else {
      print('⚠️ userId not found in StorageService');
    }
  }
  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTinderNavIcon(IconData icon, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isActive ? 1.1 : 1.0,
          child: Icon(
            icon,
            size: 26,
            color: isActive
                ? Colors.white
                : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  Widget buildAlternativeTinderBottomNav(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      extendBody: true, // Allows body to extend behind bottom nav
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: 24,
        ),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: const Color(0xFFFF4458).withOpacity(0.05),
              blurRadius: 50,
              offset: const Offset(0, 20),
              spreadRadius: 0,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / 4;

            return Stack(
              children: [
                // Animated background indicator
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutBack,
                  left: itemWidth * _currentIndex + (itemWidth / 2 - 25),
                  top: 10,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF4458),
                          Color(0xFFFF6B7A),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4458).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Navigation items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEnhancedNavIcon(Icons.explore_rounded, 0, 'Discover'),
                    _buildEnhancedNavIcon(Icons.favorite_rounded, 1, 'Likes'),
                    _buildEnhancedNavIcon(Icons.chat_bubble_rounded, 2, 'Messages'),
                    _buildEnhancedNavIcon(Icons.person_rounded, 3, 'Profile'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedNavIcon(IconData icon, int index, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isActive ? 1.2 : 1.0,
              child: Icon(
                icon,
                size: isActive ? 24 : 22,
                color: isActive
                    ? Colors.white
                    : const Color(0xFFBDBDBD),
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 2),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isActive ? 1.0 : 0.0,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Tinder background
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      // Floating bottom navigation
      bottomNavigationBar: Container(
        height: 90, // Extra height for floating effect
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: 20,
              right: 20,
              bottom: 20, // Distance from bottom
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.5), // Fully rounded
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth / 4;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Active indicator background
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                          left: itemWidth * _currentIndex + (itemWidth / 2 - 22),
                          top: 10,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF4458), // Tinder primary
                                  Color(0xFFFF6B7A), // Tinder secondary
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF4458).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Navigation icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildTinderNavIcon(Icons.explore_rounded, 0),
                            _buildTinderNavIcon(Icons.favorite_rounded, 1),
                            _buildTinderNavIcon(Icons.chat_bubble_rounded, 2),
                            _buildTinderNavIcon(Icons.person_rounded, 3),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
