import 'package:fakelingo/ui/components/swipe_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtherProfileDetailsScreen extends StatefulWidget {
  const OtherProfileDetailsScreen({
    Key? key,
    required this.imageUrls,
    required this.currentPhoto,
  }) : super(key: key);
  final List<String> imageUrls;
  final int currentPhoto;
  @override
  State<OtherProfileDetailsScreen> createState() =>
      _OtherProfileDetailsScreenState();
}

class _OtherProfileDetailsScreenState extends State<OtherProfileDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.only(bottom: 50.0)),
            ),
          ],
        ),
      ),
    );
  }
}
