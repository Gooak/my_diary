import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CalendarDataSource {
  //특정 날짜의 이벤트 가져오기
  Future<QuerySnapshot> getEvents(String email, String date);

  //총 작성한 카운트 가져오기
  Future<int> getEventTotalCount(String email);

  //특정 날짜의 이벤트 저장
  Future<void> setEvent(String email, String date, Map<String, dynamic> event);

  //모든 이벤트 가져오기
  Future<QuerySnapshot<Map<String, dynamic>>> getEventsAll(
      String email, bool sort);
}

class CalendarDataSourceImpl implements CalendarDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 특정 날짜의 이벤트 가져오기
  @override
  Future<QuerySnapshot> getEvents(String email, String date) async {
    return await _firestore
        .collection('Calendar')
        .doc(email)
        .collection(email)
        .where('date', isGreaterThanOrEqualTo: date)
        .where('date', isLessThanOrEqualTo: "$date\uf8ff")
        .get();
  }

  // 특정 날짜의 이벤트 가져오기
  @override
  Future<int> getEventTotalCount(String email) async {
    var item = await _firestore
        .collection('Calendar')
        .doc(email)
        .collection(email)
        .get();
    return item.size;
  }

  // 특정 날짜의 이벤트 저장
  @override
  Future<void> setEvent(
      String email, String date, Map<String, dynamic> event) async {
    await _firestore
        .collection('Calendar')
        .doc(email)
        .collection(email)
        .doc(date)
        .set(event);
  }

  // 모든 이벤트 가져오기
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getEventsAll(
      String email, bool sort) async {
    return await _firestore
        .collection('Calendar')
        .doc(email)
        .collection(email)
        .orderBy('timestamp', descending: sort)
        .get();
  }
}
