import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_little_memory_diary/data/todoLocalDataSource.dart';
import 'package:my_little_memory_diary/model/user_model.dart';

//로그인시 유저 정보가져오는 Repository
class UserRepository {
  static final _firebase = FirebaseFirestore.instance;

  static Future<UserInformation> loginUser(String email) async {
    var data = await _firebase.collection('UserInfo').where('email', isEqualTo: email).get();
    return UserInformation.fromJson(data.docs.first.data());
  }

  static Future<void> setFeedback(String email, String name, String feedback) async {
    await _firebase.collection('Feedback').doc(DateTime.now().toString()).set({
      'email': email,
      'name': name,
      'feedback': feedback,
      'timestamp': Timestamp.now(),
    });
  }

  static Future<void> deleteAccountReason(String email, String name, String text) async {
    await _firebase.collection('DeleteAccount').doc(DateTime.now().toString()).set({
      'email': email,
      'name': name,
      'deleteAccount': text,
      'timestamp': Timestamp.now(),
    });
  }

  static Future<void> deleteUser(String email) async {
    await _firebase.collection('UserInfo').doc(email).delete();
    var calendar = await _firebase.collection('Calendar').doc(email).collection(email).get();
    for (var calendar in calendar.docs) {
      calendar.reference.delete();
    }
    var memory = await _firebase.collection('Memory').doc(email).collection(email).get();
    for (var memory in memory.docs) {
      memory.reference.delete();
    }
    await _firebase.collection('Calendar').doc(email).delete();
    await _firebase.collection('Memory').doc(email).delete();
    await HiveLocalDataSource().myTodoAllDelete();
    try {
      final storage = FirebaseStorage.instance;
      final ref = storage.ref().child(email);
      final ListResult result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
    } catch (e) {}
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
