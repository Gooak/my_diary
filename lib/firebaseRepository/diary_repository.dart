import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_diary/model/diary_model.dart';

class DiaryRepository {
  Future<List<DiaryModel>> getDiary(String email) async {
    List<DiaryModel> events = [];
    var data = await FirebaseFirestore.instance.collection('Memory').doc(email).collection(email).orderBy('timestamp', descending: true).get();

    for (var element in data.docs) {
      events.add(DiaryModel.fromDocumentSnapshot(element));
    }
    return events;
  }

  Future<void> setDiary(String email, DiaryModel diary) async {
    await FirebaseFirestore.instance.collection('Memory').doc(email).collection(email).doc().set(diary.toJson());
  }

  Future<void> diaryDelete(String email, String documentId, String imagePath) async {
    await FirebaseFirestore.instance.collection('Memory').doc(email).collection(email).doc(documentId).delete();
    await FirebaseStorage.instance.ref().child(email).child(imagePath).delete();
  }
}
