import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_diary/localRepository/hiveRepository.dart';
import 'package:my_diary/model/calendar_model.dart';
import 'package:my_diary/firebaseRepository/calendar_repository.dart';
import 'package:my_diary/model/todo_model.dart';

class CalendarViewModel extends ChangeNotifier {
  final calendarRepository = CalendarRepository();
  MyTodoForHive hiveRepository = MyTodoForHive();

  //캘린더 메인 화면 맵리스트
  final Map<DateTime, List<CalendarModel>> _events = {};
  Map<DateTime, List<CalendarModel>> get events => _events;

  //모아보기 리스트
  List<CalendarModel> _eventList = [];
  List<CalendarModel> get eventList => _eventList;

  //투두리스트 리스트
  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;

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

  Future<void> getEventAllList(String email, bool sort) async {
    _eventList = await calendarRepository.getEventsAll(email, sort);
    notifyListeners();
  }

  //투두리스트
  Future<void> myTodoGet(DateTime selectedDay) async {
    String selectedDayString = DateFormat('yyyy-MM-dd').format(selectedDay);
    _todoList = await hiveRepository.myTodoGet(selectedDayString);
    notifyListeners();
  }

  //투두적는거
  Future<void> myTodoSet(List<TodoModel> addTodoList) async {
    await hiveRepository.myTodoSet(addTodoList);
    notifyListeners();
  }

  //투두 완료 체크
  Future<void> myTodoUpdate(int id, bool check, DateTime selectedDay) async {
    String selectedDayString = DateFormat('yyyy-MM-dd').format(selectedDay);
    _todoList = await hiveRepository.myTodoUpdate(id, check, selectedDayString);
    notifyListeners();
  }

  //투두적는거
  Future<void> myTodoDelete(List<TodoModel> deleteTodoList) async {
    await hiveRepository.myTodoDelete(deleteTodoList);
    notifyListeners();
  }
}
