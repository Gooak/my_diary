import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_diary/common/googleAd.dart';
import 'package:my_diary/view/mainPage/calendar/my_calendar.dart';
import 'package:my_diary/view/mainPage/diary/my_diary.dart';
import 'package:my_diary/view/mainPage/mypage/my_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = 0;
  List<Widget> pages = [
    const MyDiary(),
    const MyCalendar(),
    const MyPage(),
  ];
  late BannerAd banner;
  @override
  void initState() {
    super.initState();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      selectedItem = index;
      pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: selectedItem, children: pages),
          ),
          const GoogleAd(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        //material desing 버전
        destinations: const [
          NavigationDestination(icon: Icon(Icons.image_outlined, size: 30), label: '추억'),
          NavigationDestination(icon: Icon(Icons.calendar_today, size: 30), label: '일기'),
          NavigationDestination(icon: Icon(Icons.person, size: 30), label: '나'),
        ],
        height: 70,
        selectedIndex: selectedItem,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
