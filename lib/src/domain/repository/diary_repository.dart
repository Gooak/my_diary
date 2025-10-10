import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';

abstract class DiaryRepository {
  //다이어리 가져오기
  Future<List<DiaryModel>> getDiary(String email);

  //다이어리 저장
  Future<void> addDiary(String email, DiaryModel diary);

  //다이어리 수정
  Future<void> updateDiary(String email, DiaryModel diary);

  //다이어리 삭제
  Future<void> deleteDiary(String email, String documentId);
}
