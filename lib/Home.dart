import 'package:flutter/material.dart';
import 'package:my_diary/view/mainPage/my_calendar.dart';
import 'package:my_diary/view/mainPage/my_diary.dart';
import 'package:my_diary/view/mainPage/my_page.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = 0;
  late Widget currentPage;
  late int startDate;
  List<Widget> pages = [
    const MyDiary(),
    const MyCalendar(),
    const MyPage(),
  ];
  @override
  void initState() {
    startDate = DateTime.now().difference(Provider.of<UserProvider>(context, listen: false).joinDate.subtract(const Duration(days: 1))).inDays;
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
      appBar: AppBar(
        title: Row(
          children: [
            Text('$startDate일 차'),
          ],
        ),
      ),
      body: currentPage,
      bottomNavigationBar: NavigationBar(
        //material desing 버전
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home, size: 30), label: '일기'),
          NavigationDestination(icon: Icon(Icons.calendar_today, size: 30), label: '오늘'),
          NavigationDestination(icon: Icon(Icons.person, size: 30), label: '나'),
        ],
        height: 70,
        selectedIndex: selectedItem,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
