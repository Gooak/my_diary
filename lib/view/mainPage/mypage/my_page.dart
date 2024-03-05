import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final day = DateTime.now().difference(userProvider.joinDate.subtract(const Duration(days: 1))).inDays;
    DateTime? currentBackPressTime;
    Size scrrenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('나')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              '함께하신지 ${day}일 입니다!',
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Container(
            width: scrrenSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userProvider.user!.userName!,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Text(
                          userProvider.user!.email!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('피드백'),
          ),
          GestureDetector(
            child: Container(
              height: 60,
              width: scrrenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              padding: const EdgeInsets.all(15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '리뷰하기',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            onTap: () async {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
                currentBackPressTime = now;
                showCustomSnackBar(context, '한번 더 누르면 로그아웃 됩니다.');
                return;
              }
              userProvider.logOut();
              FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            child: Container(
              height: 60,
              width: scrrenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              padding: const EdgeInsets.all(15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '의견 보내기',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            onTap: () async {},
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('회원관리'),
          ),
          GestureDetector(
            child: Container(
              height: 60,
              width: scrrenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              padding: const EdgeInsets.all(15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '로그아웃',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            onTap: () async {
              DateTime now = DateTime.now();
              if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
                currentBackPressTime = now;
                showCustomSnackBar(context, '한번 더 누르면 로그아웃 됩니다.');
                return;
              }
              userProvider.logOut();
              FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(
            height: 1,
          ),
          GestureDetector(
            child: Container(
              height: 60,
              width: scrrenSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              padding: const EdgeInsets.all(15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '회원탈퇴',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Text(
                    '>',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            onTap: () async {},
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
