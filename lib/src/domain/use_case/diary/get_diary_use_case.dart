import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';

class GetDiaryUseCase {
  final DiaryRepository _diaryRepository;
  GetDiaryUseCase(this._diaryRepository);

  Future<List<DiaryModel>> getDiary(String email) async {
    return await _diaryRepository.getDiary(email);
  }
}
