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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.swipeItemModel.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.swipeItemModel.age.toString(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_downward, color: Colors.black),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  SizedBox(
                    height: 450,
                    child: SwipeCard(
                      swipeItemModel: widget.swipeItemModel,
                      controller: widget.controller,
                      swipeDirectionNotifier: widget.swipeDirectionNotifier,
                      showArrowUpIcon: false,
                      showPrimaryDetail: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: true,
                        icon: Icons.search,
                        text: 'Đang tìm kiếm',
                      ),
                      SizedBox(height: 12),
                      InfoRow(
                        icon: Icons.sentiment_satisfied,
                        text: widget.swipeItemModel.lookingFor,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: true,
                        icon: Icons.contact_emergency,
                        text: 'Thông tin chính',
                      ),
                      if (widget.swipeItemModel.basicInfo?.distance !=
                          null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.social_distance,
                          text:
                              'cách xa ${widget.swipeItemModel.basicInfo!.distance} km',
                        ),
                      ],
                      if (widget.swipeItemModel.basicInfo?.height != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.show_chart,
                          text: '${widget.swipeItemModel.basicInfo!.height} cm',
                        ),
                      ],
                      if (widget.swipeItemModel.basicInfo?.gender != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.person_3_rounded,
                          text: '${widget.swipeItemModel.basicInfo!.gender} ',
                        ),
                      ],
                      if (widget.swipeItemModel.basicInfo?.zodiac != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.nightlife_rounded,
                          text: '${widget.swipeItemModel.basicInfo!.zodiac} ',
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),

                  ProfileDetailsCard(
                    children: [
                      HeaderInfoRow(
                        trailing: true,
                        icon: Icons.contact_emergency,
                        text: 'Thông tin cơ bản',
                      ),
                      if (widget.swipeItemModel.bio != null) ...[
                        SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.label,
                          text: '${widget.swipeItemModel.bio} ',
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 10),
                  ActionContainer(
                    content: 'Chia sẻ ${widget.swipeItemModel.name}',
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                  ),
                  SizedBox(height: 10),

                  ActionContainer(
                    content: 'Chặn ${widget.swipeItemModel.name}',
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                  ),
                  SizedBox(height: 10),

                  ActionContainer(
                    content: 'Báo cáo ${widget.swipeItemModel.name}',
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
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
          ],
        ),
      ),
    );
  }
}
