import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_little_memory_diary/local_repository/hive_todo_repository.dart';
import 'package:my_little_memory_diary/model/calendar_model.dart';
import 'package:my_little_memory_diary/server_repository/calendar_repository.dart';
import 'package:my_little_memory_diary/model/todo_model.dart';
import 'package:home_widget/home_widget.dart';

class CalendarViewModel extends ChangeNotifier {
  final calendarRepository = CalendarRepository();
  MyTodoForHive hiveRepository = MyTodoForHive();

  //캘린더 메인 화면 맵리스트
  Map<DateTime, List<CalendarModel>> _events = {};
  Map<DateTime, List<CalendarModel>> get events => _events;

  //캘린더 투두 카운트
  Map<DateTime, int> _todos = {};
  Map<DateTime, int> get todos => _todos;

  //모아보기 리스트
  List<CalendarModel> _eventList = [];
  List<CalendarModel> get eventList => _eventList;

  //투두리스트 리스트
  List<TodoModel> _todoList = [];
  List<TodoModel> get todoList => _todoList;

  //실천한 투두
  int _calendarCount = 0;
  int get calendarCount => _calendarCount;

  //실천한 투두
  int _activeTodoCount = 0;
  int get activeTodoCount => _activeTodoCount;

  //총 투두
  int _todoCount = 0;
  int get todoCount => _todoCount;

  //이번달 기분 통계 차트
  late QuerySnapshot? _eventChart;
  QuerySnapshot? get eventChart => _eventChart;

  //바탕화면 투두리스트 컬러
  String _todoTextColor = "1";
  String get todoTextColor => _todoTextColor;

  Future<void> getEventList(String email, DateTime date, {bool countCheck = false, bool firstFun = false}) async {
    if (firstFun == true) {
      _events.clear();
      _calendarCount = 0;
    }
    String nowDateString = DateFormat('yyyy-MM').format(date);
    var eventGet = await calendarRepository.getEvents(email, nowDateString);
    int i = 0;
    for (i; i < eventGet.docs.length; i++) {
      List date = eventGet.docs[i]['date'].toString().split('-');
      List<CalendarModel> text = [];

      text.add(CalendarModel(
          date: eventGet.docs[i]['date'],
          weather: eventGet.docs[i]['weather'],
          mood: eventGet.docs[i]['mood'],
          moodImage: eventGet.docs[i]['moodImage'],
          timestamp: eventGet.docs[i]['timestamp']!,
          calendarCount: eventGet.docs[i]['calendarCount']!));
      _events[DateTime.utc(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))] = text;
    }
    if (countCheck == true && eventGet.docs.isNotEmpty) {
      _calendarCount = eventGet.docs[eventGet.docs.length - 1]['calendarCount'];
      _eventChart = eventGet;
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

  //투두리스트 모든 투두 리스트
  Future<void> myTodoDayCountGet(DateTime date) async {
    String nowDateString = DateFormat('yyyy-MM').format(date);
    var box =
        Hive.box<int>('todoDayCount').toMap().entries.where((entry) => entry.key.toString().contains(nowDateString));
    for (var item in box) {
      List date = item.key.toString().split('-');
      _todos[DateTime.utc(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]))] = item.value;
    }
    // notifyListeners();
  }

  //투두리스트 모든 투두 리스트
  Future<void> myTodoAllGet() async {
    _todoCount = await hiveRepository.myTodoAllGet();
    notifyListeners();
  }

  //투두리스트 모든 투두 리스트
  Future<void> myTodoAllActiveGet() async {
    _activeTodoCount = await hiveRepository.myTodoAllActiveGet();
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
    await myTodoAllGet();
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

  //투두 색상 가져오기
  Future<void> myTodoTextColorGet() async {
    _todoTextColor = await hiveRepository.myTodoTextColorGet();
    notifyListeners();
  }

  //투두 색상 변경
  Future<void> myTodoTextColorSet() async {
    _todoTextColor = await hiveRepository.myTodoTextColorSet();
    await HomeWidget.saveWidgetData<String>('todoTextColor', _todoTextColor);
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider', iOSName: 'HomeWidgetProvider');
    notifyListeners();
  }

  //홈위젯 투두 추가
  Future<void> myTodoHomeWidget({String currentPageDate = ''}) async {
    String selectedDayString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (currentPageDate != '' && selectedDayString != currentPageDate) {
      return;
    }
    final todoHomeWidget = await hiveRepository.myTodoGet(selectedDayString);

    String todoText = '';
    if (todoHomeWidget.isNotEmpty) {
      todoText = '${todoHomeWidget[0].date} 투두리스트\n';
      for (var todoItem in todoHomeWidget) {
        todoText += '${todoItem.todoText} ${todoItem.checkTodo == true ? "✔️" : "❌"}\n';
      }
    }
    await HomeWidget.saveWidgetData<String>('todoTextColor', _todoTextColor);
    await HomeWidget.saveWidgetData<String>('todoList', todoText);
    await HomeWidget.updateWidget(name: 'HomeWidgetProvider', iOSName: 'HomeWidgetProvider');
  }
}
