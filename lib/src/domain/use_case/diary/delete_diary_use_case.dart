import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';
import 'package:my_little_memory_diary/src/domain/repository/image_repository.dart';

class DeleteDiaryUseCase {
  final DiaryRepository _diaryRepository;
  final ImageRepository _imageRepository;
  DeleteDiaryUseCase(this._diaryRepository, this._imageRepository);

  Future<void> deleteDiary(
      String email, String documentId, String imagePath) async {
    await _imageRepository.deleteImage(email, imagePath);
    return await _diaryRepository.deleteDiary(email, documentId);
  }
}
