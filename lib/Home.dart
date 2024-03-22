import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_little_memory_diary/common/googleAd.dart';
import 'package:my_little_memory_diary/pageHome.dart';
import 'package:my_little_memory_diary/view/mainPage/calendar/my_calendar.dart';
import 'package:my_little_memory_diary/view/mainPage/diary/my_diary.dart';
import 'package:my_little_memory_diary/view/mainPage/mypage/my_page.dart';

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

  @pragma('vm:entry-point')
  Future<void> interactiveCallback(Uri? uri) async {
    // We check the host of the uri to determine which action should be triggered.
    if (uri?.host == 'todoOnClick') {
      _onDestinationSelected(1);
    }
  }

  void _onDestinationSelected(int index) {
    setState(() {
      selectedItem = index;
      pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    // GoogleFrontAd.initialize();
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: FadeIndexedStack(
                index: selectedItem,
                duration: const Duration(milliseconds: 150),
                children: pages,
              ),
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
      ),
    );
  }
}
