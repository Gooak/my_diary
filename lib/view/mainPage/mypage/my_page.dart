import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_little_memory_diary/common/packageInfo.dart';
import 'package:my_little_memory_diary/components/colorScheme.dart';
import 'package:my_little_memory_diary/components/dialog.dart';
import 'package:my_little_memory_diary/components/snackBar.dart';
import 'package:my_little_memory_diary/firebaseRepository/user_repository.dart';
import 'package:my_little_memory_diary/viewModel/calendar_view_model.dart';
import 'package:my_little_memory_diary/viewModel/diary_view_model.dart';
import 'package:my_little_memory_diary/viewModel/user_view_model.dart';
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

  late int day;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final diaryProvider = Provider.of<DiaryViewModel>(context, listen: true);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: true);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    day = DateTime.now().difference(userProvider.joinDate.subtract(const Duration(days: 1))).inDays;

    calendarProvider.myTodoAllGet();
    calendarProvider.myTodoAllActiveGet();

    diaryCount = diaryProvider.diaryCount;
    calendarCount = calendarProvider.calendarCount;
    todoCount = calendarProvider.todoCount;
    activeTodoCount = calendarProvider.activeTodoCount;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final selectColor = Provider.of<SelectColor>(context, listen: false);
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
            child: Text('테마 색상'),
          ),
          SizedBox(
            height: 50,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 5,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: selectColor.colorsName.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    selectColor.selectNumb = selectColor.colorsName[index]['number'];
                    selectColor.changedColor(selectColor.colorsName[index]['number']);
                  },
                  child: AnimatedPhysicalModel(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    elevation: selectColor.colorsName[index]['number'] == selectColor.selectNumb ? 6.0 : 0,
                    shape: BoxShape.rectangle,
                    shadowColor: Colors.black,
                    color: selectColor.colorsName[index]['color'],
                    borderRadius: selectColor.colorsName[index]['number'] == selectColor.selectNumb
                        ? const BorderRadius.all(Radius.circular(5))
                        : const BorderRadius.all(Radius.circular(25)),
                    child: SizedBox(
                      width: 50,
                      child: selectColor.colorsName[index]['number'] == selectColor.selectNumb
                          ? const Center(
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                );
              },
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
                feedbackController: textController,
                hintText: '촤대 30글자',
                icon: null,
                hintCount: null,
                maxLength: 30,
                circualr: 5,
                cancelAction: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  textController.text = '';
                },
                enterAction: () async {
                  if (textController.text.trim() == '') {
                    showCustomSnackBar(context, '의견을 적어주세요!');
                    return;
                  }
                  if (mounted) {
                    Navigator.pop(context);
                    showCustomSnackBar(context, '보내주셔서 감사합니다.');
                  }
                  await UserRepository.setFeedback(userProvider.user!.email!, userProvider.user!.userName!, textController.text);
                  textController.text = '';
                },
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('도움말'),
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
                        '개인정보처리방침',
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
                Uri.parse('https://sites.google.com/view/gooakcompany--privacy-policy/%ED%99%88'),
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
                        '이용약관',
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
                Uri.parse('https://sites.google.com/view/gooak-company-terms-of-service/%ED%99%88'),
                mode: LaunchMode.externalNonBrowserApplication,
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
              await userProvider.logOut();
              await FirebaseAuth.instance.signOut();
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () async {
                    textDialogFunc(
                      context: context,
                      title: '회원탈퇴',
                      text: '탈퇴 사유를 적어주세요',
                      cancel: '취소',
                      enter: '탈퇴하기',
                      feedbackController: textController,
                      hintText: '촤대 30글자',
                      icon: null,
                      hintCount: null,
                      maxLength: 30,
                      circualr: 5,
                      cancelAction: () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                        textController.text = '';
                      },
                      enterAction: () async {
                        if (textController.text.trim() == '') {
                          showCustomSnackBar(context, '의견을 적어주세요!');
                          return;
                        }
                        if (mounted) {
                          Navigator.pop(context);
                          showCustomSnackBar(context, '그동안 나의 작은 추억 일기를 이용해주셔서 감사합니다.');
                        }
                        await UserRepository.deleteAccountReason(userProvider.user!.email!, userProvider.user!.userName!, textController.text);
                        await UserRepository.deleteUser(userProvider.user!.email!);
                        textController.text = '';
                      },
                    );
                  },
                  child: const Text('회원탈퇴')),
              Text(
                'ver ${PackageInformation.packageVesion}',
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
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
