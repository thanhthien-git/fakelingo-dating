import 'package:fakelingo/ui/components/swiper_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  Color primaryPink = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SvgPicture.asset('assets/tinder_flame.svg', width: 16, height: 16),
            SizedBox(width: 5),
            Text(
              'Faketaxi',
              style: TextStyle(
                color: primaryPink,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            Spacer(),

            IconButton(
              icon: Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {},
            ),

            IconButton(
              icon: Icon(Icons.lightbulb_circle, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SwiperHome(),
    );
  }
}
