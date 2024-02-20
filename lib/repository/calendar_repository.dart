import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_diary/model/calendar_model.dart';

class CalendarRepository {
  Future<QuerySnapshot> getEvents(String email, String date) async {
    return await FirebaseFirestore.instance
        .collection('Calendar')
        .doc(email)
        .collection(email)
        .where('date', isGreaterThanOrEqualTo: date)
        .where('date', isLessThanOrEqualTo: "$date\uf8ff")
        .get();
  }

  Future<void> setEvent(String email, String date, CalendarModel event) async {
    await FirebaseFirestore.instance.collection('Calendar').doc(email).collection(email).doc(date).set(event.toJson());
  }

  Future<List<CalendarModel>> getEventsAll(String email, bool sort) async {
    List<CalendarModel> events = [];
    var data = await FirebaseFirestore.instance.collection('Calendar').doc(email).collection(email).orderBy('timestamp', descending: sort).get();

    for (var element in data.docs) {
      events.add(CalendarModel.fromDocumentSnapshot(element));
    }
    return events;
  }
}
