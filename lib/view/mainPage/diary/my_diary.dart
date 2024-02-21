import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_diary/components/dialog.dart';
import 'package:my_diary/model/diary_model.dart';
import 'package:my_diary/view/mainPage/diary/diaryAdd.dart';
import 'package:my_diary/viewModel/diary_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool sort = true;
  List<DiaryModel> diaryList = [];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return PopScope(
      canPop: !EasyLoading.isShow,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('추억 카드'),
          elevation: 0.5,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  sort = !sort;
                });
              },
              icon: Icon(sort == false ? Icons.arrow_downward : Icons.arrow_upward),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'myDiaryAdd',
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiaryAdd(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Consumer<DiaryViewModel>(
          builder: (context, provider, child) {
            provider.getDiary(userProvider.user!.email!, sort);
            diaryList = provider.diaryList;
            return diaryList.isEmpty
                ? const Center(
                    child: Text('여러분의 추억을 적어주세요.'),
                  )
                : ListView.builder(
                    itemCount: diaryList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 0.1,
                              spreadRadius: 0.1,
                            ),
                          ],
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
                                      PopupMenuButton<int>(
                                        child: const Icon(Icons.more_horiz),
                                        itemBuilder: (BuildContext context) => [
                                          const PopupMenuItem<int>(
                                            value: 1,
                                            child: Text('삭제하기'),
                                          ),
                                        ],
                                        onSelected: (int value) {
                                          if (value == 1) {
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
                                                provider.diaryDelete(userProvider.user!.email!, diary.id!, diary.imagePath);
                                              },
                                            );
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                print(diaryList[index].id);
                              },
                              child: Container(
                                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
                                  height: 400,
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
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
                                                return const Center(child: Icon(Icons.close));
                                              default:
                                                return null;
                                            }
                                          },
                                        )
                                      : const SizedBox.shrink()),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).colorScheme.primaryContainer,
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
                    },
                  );
          },
        ),
      ),
    );
  }
}
