import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_diary/model/calendar_model.dart';
import 'package:my_diary/repository/calendar_repository.dart';

class CalendarViewModel extends ChangeNotifier {
  final calendarRepository = CalendarRepository();
  final Map<DateTime, List<CalendarModel>> _events = {};
  Map<DateTime, List<CalendarModel>> get events => _events;

  List<CalendarModel> _eventList = [];
  List<CalendarModel> get eventList => _eventList;

  Future<void> getEventList(String email, DateTime date) async {
    String nowDateString = DateFormat('yyyy-MM').format(date);
    var eventGet = await calendarRepository.getEvents(email, nowDateString);
    for (int i = 0; i < eventGet.docs.length; i++) {
      List date = eventGet.docs[i]['date'].toString().split('-');
      List<CalendarModel> text = [];

      text.add(CalendarModel(
        date: eventGet.docs[i]['date'],
        weather: eventGet.docs[i]['weather'],
        mood: eventGet.docs[i]['mood'],
        timestamp: eventGet.docs[i]['timestamp']!,
      ));
      events[DateTime.utc(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))] = text;
    }
    notifyListeners();
  }

  Future<void> setEvent(String email, String date, CalendarModel event) async {
    await calendarRepository.setEvent(email, date, event);
  }
}
