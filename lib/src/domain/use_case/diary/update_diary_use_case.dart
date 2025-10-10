import 'dart:io' show File;

import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/image_repository.dart';

class UpdateDiaryUseCase {
  final DiaryRepository _diaryRepository;
  final ImageRepository _imageRepository;
  UpdateDiaryUseCase(this._diaryRepository, this._imageRepository);

  Future<void> updateDiary(String email, DiaryModel diary, File? image) async {
    String beforeImagePath = diary.imagePath;
    if (beforeImagePath.isNotEmpty) {
      await _imageRepository.deleteImage(email, beforeImagePath);
    }
    if (image != null) {
      List<String> imageFile = await _imageRepository.uploadImage(email, image);
      diary.imagePath = imageFile[0];
      diary.imageUrl = imageFile[1];
    }
    return await _diaryRepository.updateDiary(email, diary);
  }
}
