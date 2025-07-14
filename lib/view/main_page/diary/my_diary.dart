import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_little_memory_diary/components/color_scheme.dart';
import 'package:my_little_memory_diary/components/design.dart';
import 'package:my_little_memory_diary/components/dialog.dart';
import 'package:my_little_memory_diary/model/diary_model.dart';
import 'package:my_little_memory_diary/view/main_page/diary/diary_add.dart';
import 'package:my_little_memory_diary/view/main_page/diary/diary_photo_view.dart';
import 'package:my_little_memory_diary/view_model/diary_view_model.dart';
import 'package:my_little_memory_diary/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> with WidgetsBindingObserver {
  bool sort = true;
  List<DiaryModel> diaryList = [];
  TextEditingController searchController = TextEditingController();
  String textCentent = '';
  String checkDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<SelectColor>(context, listen: false).streamController.stream.listen((event) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didChangePlatformBrightness() async {
    super.didChangePlatformBrightness();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diaryProvider = Provider.of<DiaryViewModel>(context, listen: false);
    diaryProvider.getDiary(userProvider.user!.email!);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: !EasyLoading.isShow,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
      },
      child: Consumer<DiaryViewModel>(
        builder: (context, provider, child) {
          diaryList = provider.diaryList;
          return Scaffold(
            appBar: AppBar(
              title: const Text('추억 카드'),
              elevation: 0.5,
              actions: [
                SizedBox(
                  width: size.width / 2,
                  height: 40,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    controller: searchController,
                    decoration: DesignInputDecoration(
                            hintText: '검색 단어 입력', icon: const Icon(Icons.search), circular: 5, hintCount: '')
                        .inputDecoration,
                    onChanged: (value) {
                      setState(() {
                        textCentent = searchController.text;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      sort = !sort;
                      provider.reverseDiary();
                    });
                  },
                  icon: Icon(sort == false ? Icons.arrow_downward : Icons.arrow_upward),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'myDiaryAdd',
              onPressed: () async {
                // if (checkDate == provider.checkDate) {
                //   showCustomSnackBar(context, '오늘 이미 작성하셨습니다!');
                // } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryAdd(
                      sort: sort,
                      diary: null,
                    ),
                  ),
                );
                // }
              },
              child: const Icon(Icons.add),
            ),
            body: diaryList.isEmpty
                ? const Center(
                    child: Text('여러분의 추억을 적어주세요.'),
                  )
                : ListView.builder(
                    itemCount: diaryList.length,
                    itemBuilder: (context, index) {
                      if (searchController.text != "" &&
                          !diaryList[index].text.toLowerCase().contains(textCentent.toLowerCase())) {
                        return const SizedBox.shrink();
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.scrim
                                  : Theme.of(context).colorScheme.primaryContainer,
                            ),
                          ),
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          diaryList[index].date,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            PopupMenuButton<int>(
                                              child: const Icon(Icons.more_horiz),
                                              itemBuilder: (BuildContext context) => [
                                                const PopupMenuItem<int>(
                                                  value: 1,
                                                  child: Text('수정하기'),
                                                ),
                                                const PopupMenuItem<int>(
                                                  value: 2,
                                                  child: Text('삭제하기'),
                                                ),
                                              ],
                                              onSelected: (int value) {
                                                if (value == 1) {
                                                  dialogFunc(
                                                    context: context,
                                                    title: '추억카드 수정',
                                                    text: '해당 추억카드를 수정하시겠습니까?',
                                                    cancel: '아니오',
                                                    enter: '예',
                                                    cancelAction: () {
                                                      Navigator.pop(context);
                                                    },
                                                    enterAction: () {
                                                      final diary = diaryList[index];
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => DiaryAdd(sort: sort, diary: diary),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                } else {
                                                  dialogFunc(
                                                    context: context,
                                                    title: '추억카드 삭제',
                                                    text: '해당 추억카드를 삭제하시겠습니까?\n(복구 하실수 없습니다.)',
                                                    cancel: '아니오',
                                                    enter: '예',
                                                    cancelAction: () {
                                                      Navigator.pop(context);
                                                    },
                                                    enterAction: () {
                                                      final diary = diaryList[index];
                                                      Navigator.pop(context);
                                                      provider.diaryDelete(
                                                          userProvider.user!.email!, diary.id!, diary.imagePath);
                                                      provider.getDiary(userProvider.user!.email!);
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullScreenImagePage(imageUrl: diaryList[index].imageUrl),
                                      ));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Theme.of(context).colorScheme.background
                                            : Theme.of(context).colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(10.0)),
                                    height: 400,
                                    width: double.infinity,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.fromLTRB(7, 15, 7, 40),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(10.0)),
                                      width: double.infinity,
                                      child: diaryList[index].imageUrl != ""
                                          ? ExtendedImage.network(
                                              diaryList[index].imageUrl,
                                              fit: BoxFit.contain,
                                              cache: true,
                                              cacheMaxAge: const Duration(days: 3),
                                              loadStateChanged: (ExtendedImageState state) {
                                                switch (state.extendedImageLoadState) {
                                                  case LoadState.loading:
                                                    return const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: Center(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  case LoadState.completed:
                                                    return null;
                                                  case LoadState.failed:
                                                    return const SizedBox(
                                                      width: 50,
                                                      height: 50,
                                                      child: Center(
                                                        child: Icon(Icons.close),
                                                      ),
                                                    );
                                                  default:
                                                    return null;
                                                }
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Theme.of(context).colorScheme.background
                                      : Theme.of(context).colorScheme.primaryContainer,
                                ),
                                height: 80,
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                child: Center(
                                  child: Text(diaryList[index].text),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
          );
        },
      ),
    );
  }
}
