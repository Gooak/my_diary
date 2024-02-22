import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diary/components/design.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/viewModel/diary_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DiaryAdd extends StatefulWidget {
  const DiaryAdd({super.key});

  @override
  State<DiaryAdd> createState() => _DiaryAddState();
}

class _DiaryAddState extends State<DiaryAdd> {
  TextEditingController postText = TextEditingController();
  final date = DateTime.now();
  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    try {
      final image = await picker.pickImage(source: imageSource);

      setState(() {
        _image = File(image!.path); // 가져온 이미지를 _image에 저장
      });
    } catch (e) {
      print('변경안함!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diaryPorvider = Provider.of<DiaryViewModel>(context, listen: false);
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
            color: Colors.black,
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
              } else if (_image == null) {
                showCustomSnackBar(context, '이미지를 선택해주세요');
              } else {
                FocusScope.of(context).unfocus();
                await diaryPorvider.setDiary(DateFormat('yyyy-MM-dd HH:mm').format(date), postText.text, userProvider.user!.email!, _image!);
                if (context.mounted) {
                  Navigator.pop(context);
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
          child: ListView(children: [
            Container(
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
                          ? const Column(
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
                              child: Image.file(
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
          ]),
        ),
      ),
    );
  }
}
