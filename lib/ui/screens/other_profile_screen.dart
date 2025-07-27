import 'package:fakelingo/core/models/swipe_item_model.dart';
import 'package:fakelingo/ui/components/bottom_button_row.dart';
import 'package:fakelingo/ui/components/profile_details_card.dart';
import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class OtherProfileDetailsScreen extends StatefulWidget {
  final SwipeItemModel swipeItemModel;
  final SwipableStackController controller;
  final ValueNotifier<SwipeDirection?> swipeDirectionNotifier;
  final bool showPrimaryDetail;

  const OtherProfileDetailsScreen({
    Key? key,
    required this.swipeItemModel,
    required this.swipeDirectionNotifier,
    required this.controller,
    required this.showPrimaryDetail,
  }) : super(key: key);

  @override
  State<OtherProfileDetailsScreen> createState() =>
      _OtherProfileDetailsScreenState();
}

class _OtherProfileDetailsScreenState extends State<OtherProfileDetailsScreen> {
  static const _space = SizedBox(height: 16);
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.pink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String text,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: iconColor ?? Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: textColor ?? Colors.black87,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.swipeItemModel;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with image background
          SliverAppBar(
            expandedHeight: 500,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black87),
                  onPressed: () {
                    // Show more options
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: const EdgeInsets.all(16),
                child: SwipeCard(
                  swipeItemModel: model,
                  controller: widget.controller,
                  swipeDirectionNotifier: widget.swipeDirectionNotifier,
                  showArrowUpIcon: false,
                  showPrimaryDetail: false,
                ),
              ),
            ),
          ),

          // Profile content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Name and basic info
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: Text(
                              model.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            '${model.age}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      if (model.distance != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cách ${model.distance} km',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Looking for section
                if (model.lookingFor != null && model.lookingFor!.trim().isNotEmpty)
                  _buildInfoSection(
                    icon: Icons.favorite_outline,
                    title: 'Đang tìm kiếm',
                    children: [
                      _buildInfoItem(
                        icon: Icons.sentiment_satisfied,
                        text: model.lookingFor!,
                      ),
                    ],
                  ),

                // Basic info section
                _buildInfoSection(
                  icon: Icons.person_outline,
                  title: 'Thông tin cơ bản',
                  children: [
                    _buildInfoItem(
                      icon: Icons.wc,
                      text: model.gender,
                    ),
                    if (model.distance != null)
                      _buildInfoItem(
                        icon: Icons.social_distance,
                        text: 'Cách ${model.distance} km',
                      ),
                  ],
                ),

                // Bio section
                if (model.bio != null && model.bio!.trim().isNotEmpty)
                  _buildInfoSection(
                    icon: Icons.info_outline,
                    title: 'Giới thiệu',
                    children: [
                      Text(
                        model.bio!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Action buttons
                _buildActionButton(
                  text: 'Chia sẻ ${model.name}',
                  icon: Icons.share_outlined,
                  onTap: () {
                    // Handle share
                  },
                ),

                _buildActionButton(
                  text: 'Chặn ${model.name}',
                  icon: Icons.block_outlined,
                  onTap: () {
                    // Handle block
                  },
                ),

                _buildActionButton(
                  text: 'Báo cáo ${model.name}',
                  icon: Icons.report_outlined,
                  textColor: Colors.red,
                  onTap: () {
                    // Handle report
                  },
                ),

                const SizedBox(height: 120), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),

      // Bottom action buttons
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomButtonsRow(
            isShortRow: true,
            onSwipe: (direction) {
              widget.controller.next(swipeDirection: direction);
              Navigator.of(context).pop();
            },
            onRewindTap: widget.controller.rewind,
            canRewind: widget.controller.canRewind,
            swipeDirectionNotifier: widget.swipeDirectionNotifier,
          ),
        ),
      ),
    );
  }
}