import 'package:fakelingo/core/models/user_model.dart';
import 'package:fakelingo/core/services/user_service.dart';
import 'package:fakelingo/ui/components/animate_toast.dart';
import 'package:flutter/material.dart';
import 'media_screen.dart';
import 'settings_screen.dart';
import 'edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int _pageIndex = 0;
  final PageController _pageController = PageController();
  final _userService = UserService();
  User? _user;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _userService.myProfile();
      if (response != null) {
        setState(() {
          _user = response;
        });
      } else {
        AnimatedToast.show(context, "Không thể lấy thông tin người dùng");
      }
    } catch (e) {
      AnimatedToast.show(context, "Lỗi");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [Color(0xFFFFE0E6), Color(0xFFFFF5F8)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh:  fetchProfile, // Kéo để refresh
            color: const Color(0xFFFF6B9D),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Bắt buộc phải có để RefreshIndicator hoạt động
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Header
                  _buildHeader(),

                  const SizedBox(height: 30),

                  // Avatar
                  _buildAnimatedAvatar(),

                  const SizedBox(height: 25),

                  // Name and stats
                  _buildNameAndStats(),

                  const SizedBox(height: 30),

                  // Buttons
                  _buildGlassmorphismButtons(),

                  const SizedBox(height: 40),

                  const SizedBox(height: 35),

                  // Premium carousel
                  _buildPremiumCarousel(),

                  const SizedBox(height: 30),

                  // Premium CTA
                  _buildPremiumCTA(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: const Color(0xFFFF6B9D).withOpacity(0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.menu, color: Color(0xFF2C2C2C), size: 20),
          ),
          const Text(
            'Profile',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B9D).withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF2C2C2C),
                  size: 20,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B9D),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Main avatar
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: _user?.profile?.photos.isNotEmpty == true
                    ? NetworkImage(_user!.profile!.photos.first)
                    : const AssetImage('assets/blur_background.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Online indicator
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF00E676),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E676).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameAndStats() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _user?.profile?.name ?? '',
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF1DE9B6)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E676).withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${_user?.profile?.age ?? ''} • ${_user?.profile?.bio ?? ''}',
          style: TextStyle(
            color: const Color(0xFF2C2C2C).withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String number,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            number,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF2C2C2C).withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphismButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: _buildGlassButton(Icons.settings_outlined, 'Settings', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildGlassButton(Icons.edit_outlined, 'Edit Profile', () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: _user!),
                ),
              );

              if (result == true) { // chỉ reload khi đã lưu thành công
                await fetchProfile(); // fetch dữ liệu mới
              }
            }),
          ),

          const SizedBox(width: 15),
          Expanded(
            child: _buildGlassButton(
              Icons.add_photo_alternate_outlined,
              'Add Photos',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MediaScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFF6B9D).withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF2C2C2C), size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(
    String emoji,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFF2C2C2C).withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _pageIndex = index),
            children: const [
              _PremiumSlide(
                title: 'Fakelingo Platinum',
                subtitle: 'See who likes you before you swipe',
                icon: Icons.diamond_outlined,
                gradient: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
              ),
              _PremiumSlide(
                title: 'Priority Likes',
                subtitle: 'Your likes are seen first',
                icon: Icons.rocket_launch_outlined,
                gradient: [Color(0xFF00E676), Color(0xFF1DE9B6)],
              ),
              _PremiumSlide(
                title: 'Super Boost',
                subtitle: '100x more profile views',
                icon: Icons.flash_on_outlined,
                gradient: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _pageIndex == index ? 30 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _pageIndex == index
                        ? const Color(0xFFFF6B9D)
                        : const Color(0xFF2C2C2C).withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPremiumCTA() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B9D), Color(0xFFFFB3D1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'UPGRADE TO PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumSlide extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _PremiumSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: gradient[0].withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: const Color(0xFF2C2C2C).withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
