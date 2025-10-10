import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class UserDataSource {
  //로그인 
  Future<QuerySnapshot<Map<String, dynamic>>> verifyUser(String email);

  //피드백
  Future<void> setFeedback(String email, String name, String feedback);

  //탈퇴사유
  Future<void> deleteAccountReason(String email, String name, String text);

  //회원탈퇴
  Future<void> deleteUser(String email);
}

class UserDataSourceImpl implements UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //로그인
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> verifyUser(String email) async {
    return await _firestore.collection('UserInfo').where('email', isEqualTo: email).get();
  }

  //피드백
  @override
  Future<void> setFeedback(String email, String name, String feedback) async {
    await _firestore.collection('Feedback').doc(DateTime.now().toString()).set({
      'email': email,
      'name': name,
      'feedback': feedback,
      'timestamp': Timestamp.now(),
    });
  }

  //탈퇴사유
  @override
  Future<void> deleteAccountReason(String email, String name, String text) async {
    await _firestore.collection('DeleteAccount').doc(DateTime.now().toString()).set({
      'email': email,
      'name': name,
      'deleteAccount': text,
      'timestamp': Timestamp.now(),
    });
  }

  //회원탈퇴
  @override
  Future<void> deleteUser(String email) async {
    await _firestore.collection('UserInfo').doc(email).delete();
    var calendar = await _firestore.collection('Calendar').doc(email).collection(email).get();
    for (var calendar in calendar.docs) {
      calendar.reference.delete();
    }
    var memory = await _firestore.collection('Memory').doc(email).collection(email).get();
    for (var memory in memory.docs) {
      memory.reference.delete();
    }
    await _firestore.collection('Calendar').doc(email).delete();
    await _firestore.collection('Memory').doc(email).delete();
    
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(email);
    final ListResult result = await ref.listAll();
    for (final item in result.items) {
      await item.delete();
    }
    
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    }

  }
}