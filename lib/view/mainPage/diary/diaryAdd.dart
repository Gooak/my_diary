import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary/common/googleAd.dart';
import 'package:my_diary/common/googleFrontAd.dart';
import 'package:my_diary/components/design.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/model/diary_model.dart';
import 'package:my_diary/viewModel/diary_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryAdd extends StatefulWidget {
  DiaryAdd({super.key, required this.sort, required this.diary});

  DiaryModel? diary;
  bool sort;

  @override
  State<DiaryAdd> createState() => _DiaryAddState();
}

class _DiaryAddState extends State<DiaryAdd> {
  TextEditingController postText = TextEditingController();
  DateTime date = DateTime.now();
  File? _image;
  final picker = ImagePicker();
  bool imageSelect = false;

  Future getImage(ImageSource imageSource) async {
    try {
      final image = await picker.pickImage(source: imageSource);

      setState(() {
        imageSelect = true;
        _image = File(image!.path); // 가져온 이미지를 _image에 저장
      });
    } catch (e) {
      if (widget.diary == null) {
        imageSelect = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.diary != null) {
      postText.text = widget.diary!.text;
      date = widget.diary!.timestamp!.toDate();
      imageSelect = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diaryProvider = Provider.of<DiaryViewModel>(context, listen: false);
    return PopScope(
      canPop: !EasyLoading.isShow,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
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
            if (EasyLoading.isShow == false) {
              if (postText.text.trim() == "") {
                showCustomSnackBar(context, '추억을 적어주세요');
              } else if (imageSelect == false) {
                showCustomSnackBar(context, '이미지를 선택해주세요');
              } else {
                FocusScope.of(context).unfocus();
                await GoogleFrontAd.initialize();
                if (widget.diary == null) {
                  await diaryProvider.setDiary(
                    DateFormat('yyyy-MM-dd HH:mm').format(date),
                    postText.text,
                    userProvider.user!.email!,
                    _image!,
                  );
                } else {
                  await diaryProvider.updateDiary(
                    DateFormat('yyyy-MM-dd HH:mm').format(date),
                    postText.text,
                    userProvider.user!.email!,
                    _image,
                    widget.diary!,
                  );
                }
                await diaryProvider.getDiary(userProvider.user!.email!);
                if (widget.sort = false) {
                  await diaryProvider.reverseDiary();
                }
                if (context.mounted) {
                  Navigator.pop(context);
                  GoogleFrontAd.loadInterstitialAd();
                }
              }
            }
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
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.primaryContainer,
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
                      onTap: () {
                        getImage(ImageSource.gallery);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
                        height: 400,
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: _image == null
                            ? widget.diary != null
                                ? ClipRRect(
                                    child: ExtendedImage.network(
                                      widget.diary!.imageUrl,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : const Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '이미지 선택',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Icon(Icons.check, color: Colors.white),
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
                    Container(
                      height: 80,
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        maxLines: null,
                        expands: true,
                        maxLength: 50,
                        decoration: DesignInputDecoration(hintText: '추억을 적어주세요 (최대 50글자)', icon: null, circular: 10, hintCount: '').inputDecoration,
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
            ],
          ),
        ),
      ),
    );
  }
}
