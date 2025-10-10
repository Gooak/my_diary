import 'package:my_little_memory_diary/src/data/remote_data_source/diary_data_source.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/domain/model/diary_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryDataSource _dataSource;
  DiaryRepositoryImpl(this._dataSource);

  //다이어리 가져오기
  @override
  Future<List<DiaryModel>> getDiary(String email) async {
    List<DiaryModel> events = [];
    var data = await _dataSource.getDiary(email);

    for (var element in data.docs) {
      events.add(DiaryModel.fromDocumentSnapshot(element));
    }
    return events;
  }

  //다이어리 저장
  @override
  Future<void> addDiary(String email, DiaryModel diary) async {
    try {
      await _dataSource.addDiary(email, diary.toJson());
    } catch (_) {
      throw ErrorException('다이어리 추가 실패');
    }
  }

  //다이어리 수정
  @override
  Future<void> updateDiary(String email, DiaryModel diary) async {
    try {
      await _dataSource.updateDiary(email, diary.toJson(), diary.id!);
    } catch (_) {
      throw ErrorException('다이어리 수정 실패');
    }
  }

  //다이어리 삭제
  @override
  Future<void> deleteDiary(String email, String documentId) async {
    try {
      await _dataSource.deleteDiary(email, documentId);
    } catch (_) {
      throw ErrorException('다이어리 삭제 실패');
    }
  }
}
