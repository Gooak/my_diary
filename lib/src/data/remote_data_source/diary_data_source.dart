import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DiaryDataSource {
  //다이어리 가져오기
  Future<QuerySnapshot<Map<String, dynamic>>> getDiary(String email);

  //다이어리 저장
  Future<void> addDiary(String email, Map<String, dynamic> diary);

  //다이어리 수정
  Future<void> updateDiary(String email, Map<String, dynamic> diary, String id);

  //다이어리 삭제
  Future<void> deleteDiary(String email, String documentId);
}

class DiaryDataSourceImpl implements DiaryDataSource {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  //다이어리 가져오기
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getDiary(String email) async {
    return await _firebase
        .collection('Memory')
        .doc(email)
        .collection(email)
        .orderBy('timestamp', descending: true)
        .get();
  }

  //다이어리 저장
  @override
  Future<void> addDiary(String email, Map<String, dynamic> diary) async {
    await _firebase
        .collection('Memory')
        .doc(email)
        .collection(email)
        .doc()
        .set(diary);
  }

  //다이어리 수정
  @override
  Future<void> updateDiary(
      String email, Map<String, dynamic> diary, String id) async {
    await _firebase
        .collection('Memory')
        .doc(email)
        .collection(email)
        .doc(id)
        .set(diary);
  }

  //다이어리 삭제
  @override
  Future<void> deleteDiary(String email, String documentId) async {
    await _firebase
        .collection('Memory')
        .doc(email)
        .collection(email)
        .doc(documentId)
        .delete();
  }
}
