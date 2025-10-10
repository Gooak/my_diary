import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/utils/search_text.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/dialog.dart';
import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/diary/diary_add.dart'
    show DiaryAdd;
import 'package:my_little_memory_diary/src/presentation/features/main_page/diary/diary_photo_view.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/diary_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class MyDiary extends ConsumerStatefulWidget {
  const MyDiary({super.key});

  @override
  ConsumerState<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends ConsumerState<MyDiary> with WidgetsBindingObserver {
  bool sortAscending = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaryAsyncValue = ref.watch(diaryNotifierProvider);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _appbar(size),
      floatingActionButton: FloatingActionButton(
        heroTag: 'myDiaryAdd',
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiaryAdd(diary: null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: diaryAsyncValue.when(
        data: (diaries) {
          final filteredDiaries = diaries.where((diary) {
            if (searchController.text.isEmpty) return true;
            return diary.text
                .contains(SearchText.matcher(searchController.text));
          }).toList();

          final sortedDiaries = sortAscending
              ? filteredDiaries
              : filteredDiaries.reversed.toList();

          if (sortedDiaries.isEmpty) {
            return const Center(
              child: Text('여러분의 추억을 적어주세요.'),
            );
          }

          return ListView.builder(
            itemCount: sortedDiaries.length,
            itemBuilder: (context, index) {
              return _diaryItem(sortedDiaries[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('일시적인 오류가 발생했습니다.')),
      ),
    );
  }

  //Appbar
  PreferredSizeWidget _appbar(Size size) {
    return AppBar(
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
              hintText: '검색 단어 입력',
              icon: const Icon(Icons.search),
              circular: 5,
              hintCount: '',
            ).inputDecoration,
            onChanged: (value) {
              setState(() {
                searchController.text;
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              sortAscending = !sortAscending;
            });
          },
          icon: Icon(sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
        ),
      ],
    );
  }

  //다이어리 아이템
  Widget _diaryItem(DiaryModel diaryItem) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  diaryItem.date,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiaryAdd(diary: diaryItem),
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
                        enterAction: () async {
                          await ref
                              .read(diaryNotifierProvider.notifier)
                              .deleteDiary(
                                  ref.read(userNotifierProvider).value!.email!,
                                  diaryItem);
                          if (mounted) Navigator.pop(context);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FullScreenImagePage(imageUrl: diaryItem.imageUrl),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10.0),
              ),
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
                  borderRadius: BorderRadius.circular(10.0),
                ),
                width: double.infinity,
                child: diaryItem.imageUrl != ""
                    ? ExtendedImage.network(
                        diaryItem.imageUrl,
                        fit: BoxFit.contain,
                        cache: true,
                        cacheMaxAge: const Duration(days: 3),
                        loadStateChanged: (ExtendedImageState state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            case LoadState.completed:
                              return null;
                            case LoadState.failed:
                              return const SizedBox(
                                width: 50,
                                height: 50,
                                child: Center(child: Icon(Icons.close)),
                              );
                          }
                        },
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.primaryContainer,
            ),
            height: 80,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(diaryItem.text),
            ),
          ),
        ],
      ),
    );
  }
}
