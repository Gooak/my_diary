import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/services/image_service.dart';
import 'package:my_little_memory_diary/src/core/services/loading_service.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/google_ad.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/google_front_ad.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:intl/intl.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/diary_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class DiaryAdd extends ConsumerStatefulWidget {
  const DiaryAdd({super.key, required this.diary});

  final DiaryModel? diary;

  @override
  ConsumerState<DiaryAdd> createState() => _DiaryAddState();
}

class _DiaryAddState extends ConsumerState<DiaryAdd> {
  TextEditingController postText = TextEditingController();
  DateTime date = DateTime.now();
  File? _image;

  @override
  void initState() {
    super.initState();
    GoogleFrontAd.initialize();
    if (widget.diary != null) {
      postText.text = widget.diary!.text;
      date = widget.diary!.timestamp!.toDate();
    }
  }

  @override
  void dispose() {
    postText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    ref.listen<AsyncValue<void>>(
      diaryNotifierProvider,
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

    final user = ref.watch(userNotifierProvider).value;
    final diary = ref.watch(diaryNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '추억카드 만들기',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'myDiaryAdd',
        onPressed: () async {
          LoadingOverlayService.runWithLoading(context, () async {
            if (postText.text.trim() == "") {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(("추억을 적어주세요"))),
              );
            } else if (_image == null) {
              scaffoldMessenger.showSnackBar(
                SnackBar(content: Text(("이미지를 선택해주세요"))),
              );
            } else {
              FocusScope.of(context).unfocus();
              if (widget.diary == null) {
                await diary.addDiary(
                  DateFormat('yyyy-MM-dd HH:mm').format(date),
                  postText.text,
                  user!.email!,
                  _image!,
                );
              } else {
                await diary.updateDiary(
                  postText.text,
                  user!.email!,
                  widget.diary!,
                  _image,
                );
              }
              if (context.mounted) {
                Navigator.pop(context);
                GoogleFrontAd.loadInterstitialAd();
              }
            }
          });
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text('저장')
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
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
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _image = await ref.read(imageProvider).getImage();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 400,
                      width: double.infinity,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.fromLTRB(7, 15, 7, 40),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        width: double.infinity,
                        child: _image == null
                            ? widget.diary != null
                                ? ClipRRect(
                                    child: ExtendedImage.network(
                                      widget.diary!.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '이미지 선택',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.black),
                                      ),
                                      Icon(Icons.check,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black),
                                    ],
                                  )
                            : ClipRRect(
                                child: ExtendedImage.file(
                                  File(_image!.path),
                                  fit: BoxFit.contain,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    margin: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      maxLength: 50,
                      decoration: DesignInputDecoration(
                              hintText: '추억을 적어주세요 (최대 50글자)',
                              icon: null,
                              circular: 10,
                              hintCount: '')
                          .inputDecoration,
                      textAlign: TextAlign.center,
                      controller: postText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const GoogleAd(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
