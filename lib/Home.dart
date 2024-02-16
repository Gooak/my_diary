import 'package:flutter/material.dart';
import 'package:my_diary/view/mainPage/my_calendar.dart';
import 'package:my_diary/view/mainPage/my_diary.dart';
import 'package:my_diary/view/mainPage/my_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = 0;
  late Widget currentPage;
  List<Widget> pages = [
    const MyDiary(),
    const MyCalendar(),
    const MyPage(),
  ];
  @override
  void initState() {
    currentPage = pages[0];
    super.initState();
  }

  void _onDestinationSelected(int index) {
    setState(() {
      selectedItem = index;
      currentPage = pages[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: NavigationBar(
        //material desing 버전
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home, size: 30), label: '메모'),
          NavigationDestination(icon: Icon(Icons.calendar_today, size: 30), label: 'Day'),
          NavigationDestination(icon: Icon(Icons.person, size: 30), label: '내 정보'),
        ],
        height: 70,
        selectedIndex: selectedItem,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}