import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_diary/common/packageInfo.dart';
import 'package:my_diary/components/dialog.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/firebaseRepository/user_repository.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/diary_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int diaryCount = 0;
  int calendarCount = 0;
  int todoCount = 0;
  int activeTodoCount = 0;

  DateTime? currentBackPressTime;

  TextEditingController feedbackConrtoller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diaryProvider = Provider.of<DiaryViewModel>(context, listen: true);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: true);
    final day = DateTime.now().difference(userProvider.joinDate.subtract(const Duration(days: 1))).inDays;

    calendarProvider.myTodoAllGet();
    calendarProvider.myTodoAllActiveGet();

    diaryCount = diaryProvider.diaryCount;
    calendarCount = calendarProvider.calendarCount;
    todoCount = calendarProvider.todoCount;
    activeTodoCount = calendarProvider.activeTodoCount;

    Size scrrenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('나')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '함께하신지 $day일 입니다!',
              style: const TextStyle(fontSize: 25),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: scrrenSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondaryContainer,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '총 작성한 추억카드',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              diaryCount.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '총 작성한 일기',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              calendarCount.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: scrrenSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Theme.of(context).colorScheme.secondaryContainer,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '총 작성한 투두',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              todoCount.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '실천한 투두',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              activeTodoCount.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
          InkWell(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            onTap: () async {
              await launchUrl(
                Uri.parse('https://play.google.com/store/apps/details?id=com.mydiary'),
                mode: LaunchMode.externalNonBrowserApplication,
              );
            },
          ),
          const SizedBox(
            height: 1,
          ),
          InkWell(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            onTap: () async {
              textDialogFunc(
                context: context,
                title: '의견 보내기',
                text: '여러분들의 의견을 보내주세요',
                cancel: '취소',
                enter: '보내기',
                feedbackController: feedbackConrtoller,
                hintText: '촤대 30글자',
                icon: null,
                hintCount: null,
                circualr: 5,
                cancelAction: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  feedbackConrtoller.text = '';
                },
                enterAction: () async {
                  if (feedbackConrtoller.text.trim() == '') {
                    showCustomSnackBar(context, '의견을 적어주세요!');
                    return;
                  }
                  if (mounted) {
                    Navigator.pop(context);
                    showCustomSnackBar(context, '보내주셔서 감사합니다.');
                  }
                  await UserRepository.setFeedback(userProvider.user!.email!, userProvider.user!.userName!, feedbackConrtoller.text);
                  feedbackConrtoller.text = '';
                },
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('회원관리'),
          ),
          InkWell(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            height: 30,
          ),
          Text(
            'ver ${PackageInformation.packageVesion}',
            textAlign: TextAlign.end,
          ),
          // const SizedBox(
          //   height: 1,
          // ),
          // InkWell(
          //   child: Container(
          //     height: 60,
          //     width: scrrenSize.width,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: Theme.of(context).colorScheme.secondaryContainer,
          //     ),
          //     padding: const EdgeInsets.all(15),
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text(
          //               '회원탈퇴',
          //               style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          //             ),
          //           ],
          //         ),
          //         Text(
          //           '>',
          //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //         )
          //       ],
          //     ),
          //   ),
          //   onTap: () async {},
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
        ]),
      ),
    );
  }
}
