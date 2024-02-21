import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/components/loading.dart';
import 'package:my_diary/model/diary_model.dart';
import 'package:my_diary/repository/diary_repository.dart';
import 'package:path/path.dart' as path;

class DiaryViewModel extends ChangeNotifier {
  DiaryRepository diaryRepository = DiaryRepository();
  List<DiaryModel> _diaryList = [];
  List<DiaryModel> get diaryList => _diaryList;

  Future<void> getDiary(String email, bool sort) async {
    _diaryList = await diaryRepository.getDiary(email, sort);
    notifyListeners();
  }

  Future<void> setDiary(String nowDate, String text, String email, File image) async {
    showLoading();
    String extension = '${DateTime.now()}${path.extension(image.path)}';
    final putImage = FirebaseStorage.instance.ref().child(email).child(extension);
    await putImage.putFile(image, SettableMetadata(contentType: 'image/jpg'));
    final imageUrl = await putImage.getDownloadURL();
    var diary = DiaryModel(date: nowDate, text: text, imageUrl: imageUrl, timestamp: Timestamp.now(), imagePath: extension);
    await diaryRepository.setDiary(email, diary);
    notifyListeners();
    dismissLoading();
  }

  Future<void> diaryDelete(String email, String documentId, String imagePath) async {
    showLoading();
    await diaryRepository.diaryDelete(email, documentId, imagePath);
    dismissLoading();
  }
}
