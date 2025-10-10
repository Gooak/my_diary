import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/constants.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/backup_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/my_page_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/theme_provider.dart';
import 'package:my_little_memory_diary/src/core/services/package_info.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/dialog.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/my_page_design_container.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/loading_service.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  DateTime? currentBackPressTime;
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColorIndex = ref.watch(themeNotifierProvider);
    final themeColor = ref.read(themeNotifierProvider.notifier);

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    ref.listen<AsyncValue<void>>(
      backupNotifierProvider,
      (previous, next) {
        if (next is AsyncError) {
          if (next.error is ErrorException) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text((next.error as ErrorException).message)),
            );
          }
        }
      },
    );

    ref.listen<AsyncValue<void>>(
      backupNotifierProvider,
      (previous, next) {
        if (next is AsyncError) {
          if (next.error is ErrorException) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text((next.error as ErrorException).message)),
            );
          }
        }
      },
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('나')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(children: [
          _myPageInfo(size),
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
              itemCount: themeColor.colorsName.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    themeColor
                        .changeColor(themeColor.colorsName[index]['number']);
                  },
                  child: AnimatedPhysicalModel(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    elevation: 0.0,
                    shape: BoxShape.rectangle,
                    shadowColor: Colors.black,
                    color: themeColor.colorsName[index]['color'],
                    borderRadius: themeColor.colorsName[index]['number'] ==
                            themeColorIndex
                        ? const BorderRadius.all(Radius.circular(5))
                        : const BorderRadius.all(Radius.circular(25)),
                    child: SizedBox(
                      width: 50,
                      child: themeColor.colorsName[index]['number'] ==
                              themeColorIndex
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
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '리뷰하기',
            rightText: '>',
            onTap: () async {
              await launchUrl(
                Uri.parse(appStoreUrl!),
                mode: LaunchMode.externalNonBrowserApplication,
              );
            },
          ),
          const SizedBox(
            height: 1,
          ),
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '의견보내기',
            rightText: '>',
            onTap: () async {
              textDialogFunc(
                context: context,
                title: '의견 보내기',
                text: '여러분들의 의견을 보내주세요',
                cancel: '취소',
                enter: '보내기',
                feedbackController: textController,
                hintText: '촤대 100글자',
                icon: null,
                hintCount: null,
                maxLength: 100,
                circualr: 5,
                cancelAction: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                  textController.text = '';
                },
                enterAction: () async {
                  LoadingOverlayService.runWithLoading(context, () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    final user = ref.read(userNotifierProvider).value;
                    final userNotifier =
                        ref.read(userNotifierProvider.notifier);

                    if (textController.text.trim() == '') {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(("의견을 적어주세요!"))),
                      );
                      return;
                    }
                    userNotifier.setFeedback(
                        user!.email!, user.userName!, textController.text);
                    textController.text = '';

                    if (mounted) {
                      Navigator.pop(context);
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(("보내주셔서 감사합니다."))),
                      );
                    }
                  });
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
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '개인정보처리방침',
            rightText: '>',
            onTap: () async {
              await launchUrl(
                Uri.parse(privacyPolicy!),
                mode: LaunchMode.externalNonBrowserApplication,
              );
            },
          ),
          const SizedBox(
            height: 1,
          ),
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '이용약관',
            rightText: '>',
            onTap: () async {
              await launchUrl(
                Uri.parse(termsOfUse!),
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
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '투두리스트 백업',
            rightText: '>',
            onTap: () async {
              dialogFunc(
                context: context,
                title: '투두리스트 백업',
                text:
                    '지금까지 작성 해오신 투두리스트를 백업 하시겠습니까?\n이미 백업 파일이 있으신 경우 백업이 덮어쓰여집니다.\n기기변경 하실 예정이시거나, 앱을 삭제하고 다시 다운받을때 이용합니다.',
                cancel: '아니오',
                enter: '예',
                cancelAction: () {
                  Navigator.pop(context);
                },
                enterAction: () async {
                  LoadingOverlayService.runWithLoading(context, () async {
                    Navigator.pop(context);
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    await ref
                        .read(backupNotifierProvider.notifier)
                        .backUpDrive();
                    if (context.mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(content: Text(("투두 리스트 백업 완료"))),
                      );
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(
            height: 1,
          ),
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '투두리스트 복원',
            rightText: '>',
            onTap: () async {
              dialogFunc(
                context: context,
                title: '투두리스트 복원',
                text:
                    '투두 리스트를 복원 하시겠습니까?\n(주의) 이미 작성되어 있는경우 지워지고 복원된 파일로 대체됩니다!',
                cancel: '아니오',
                enter: '예',
                cancelAction: () {
                  Navigator.pop(context);
                },
                enterAction: () async {
                  LoadingOverlayService.runWithLoading(context, () async {
                    Navigator.pop(context);

                    final scaffoldMessenger = ScaffoldMessenger.of(context);

                    await ref
                        .read(backupNotifierProvider.notifier)
                        .downloadDrive();
                    if (context.mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                            content: Text(("투두 리스트 복원 완료\r\n앱을 다시 실행해주세요."))),
                      );
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(
            height: 1,
          ),
          customButtonContainer(
            context: context,
            screenSize: size,
            leftText: '로그아웃',
            rightText: '>',
            onTap: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              DateTime now = DateTime.now();
              if (currentBackPressTime == null ||
                  now.difference(currentBackPressTime!) >
                      const Duration(seconds: 2)) {
                currentBackPressTime = now;

                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(("한번 더 누르면 로그아웃 됩니다."))),
                );
                return;
              }
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
                        LoadingOverlayService.runWithLoading(context, () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);

                          final user = ref.read(userNotifierProvider).value;
                          final userNotifier =
                              ref.read(userNotifierProvider.notifier);
                          if (textController.text.trim() == '') {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(("탈퇴 사유를 적어주세요."))),
                            );
                            return;
                          }

                          userNotifier.deleteUser(user!.email!, user.userName!,
                              textController.text);
                          textController.text = '';

                          if (mounted) {
                            Navigator.pop(context);
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                  content:
                                      Text(("그동안 나의 작은 추억 일기를 이용해주셔서 감사합니다."))),
                            );
                          }
                        });
                      },
                    );
                  },
                  child: const Text('회원탈퇴')),
              Text(
                'ver ${PackageInfoService.packageVesion}',
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }

  // 마이 페이지 정보들
  Widget _myPageInfo(Size size) {
    final myPageNotifier = ref.watch(myPageDataProvider);

    return myPageNotifier.when(
        data: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '함께하신지 ${myPageNotifier.value!.day}일 입니다!',
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
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
                                  myPageNotifier.value!.diaryCount.toString(),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
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
                                  myPageNotifier.value!.calendarCount
                                      .toString(),
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
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
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
                                      myPageNotifier.value!.todoCount
                                          .toString(),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
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
                                      myPageNotifier.value!.activeTodoCount
                                          .toString(),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '투두 달성률',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: size.width - 50,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      Colors.grey,
                                    ],
                                    stops: [
                                      (myPageNotifier.value!.activeTodoCount /
                                              myPageNotifier.value!.todoCount)
                                          .toDouble(),
                                      (myPageNotifier.value!.activeTodoCount /
                                              myPageNotifier.value!.todoCount)
                                          .toDouble(),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('일시적인 오류가 발생했습니다.')));
  }
}
