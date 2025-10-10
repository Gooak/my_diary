import 'dart:io';

import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/image_repository.dart';

class AddDiaryUseCase {
  final DiaryRepository _diaryRepository;
  final ImageRepository _imageRepository;
  AddDiaryUseCase(this._diaryRepository, this._imageRepository);

  Future<void> addDiary(String email, DiaryModel diary, File? image) async {
    if (image != null) {
      List<String> imageFile = await _imageRepository.uploadImage(email, image);
      diary.imagePath = imageFile[0]; //extension
      diary.imageUrl = imageFile[1]; // imageUrl
    }
    return await _diaryRepository.addDiary(email, diary);
  }
}
