import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/model/calendar_model.dart';
import 'package:my_diary/model/todo_model.dart';
import 'package:my_diary/view/mainPage/calendar/calendarAdd.dart';
import 'package:my_diary/view/mainPage/calendar/todoListAdd.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  TextEditingController textController = TextEditingController();
  late DateTime firstDate;
  DateTime nowDate = DateTime.now();

  List<CalendarModel> _selectedEvents = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  late DateTime checkDate;

  Map<DateTime, List<CalendarModel>> events = {};

  List<TodoModel> todoList = [];

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents = _getEventsForDay(selectedDay);
    }
  }

  List<CalendarModel> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  List<String> getEventsForDay(DateTime day) {
    final List<CalendarModel> eventsForDay = events[day] ?? [];

    if (eventsForDay.isNotEmpty) {
      return [eventsForDay[0].weather]; // 첫 번째 이벤트의 weather를 반환
    } else {
      return []; // 이벤트가 없는 경우 null 반환
    }
  }

  @override
  void initState() {
    super.initState();
    checkDate = DateTime.utc(nowDate.year, nowDate.month, nowDate.day);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
    firstDate = userProvider.joinDate;
    _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    calendarProvider.getEventList(userProvider.user!.email.toString(), nowDate);
    calendarProvider.myTodoGet(nowDate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CalendarViewModel>(builder: (context, provider, child) {
      _selectedEvents = _getEventsForDay(_selectedDay!);
      events = provider.events;
      todoList = provider.todoList;
      return Scaffold(
        floatingActionButton: SpeedDial(
          heroTag: 'CalendarAdd',
          animatedIcon: AnimatedIcons.menu_close,
          useRotationAnimation: true,
          animationCurve: Curves.elasticInOut,
          children: [
            SpeedDialChild(
              child: const Text('Today'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarAdd(event: events[checkDate]?.first),
                  ),
                );
              },
            ),
            SpeedDialChild(
              child: const Text('Todo'),
              onTap: () async {
                final String? date = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TodoListAdd(),
                  ),
                );
                if (date != null) {
                  if (DateFormat('yyyy-MM-dd').format(_selectedDay!) == date) {
                    provider.myTodoGet(_selectedDay!);
                  }
                }
              },
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: TableCalendar(
                  onFormatChanged: (format) {
                    return;
                  },
                  daysOfWeekHeight: 50,
                  headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  locale: 'ko_KR', // 추가
                  firstDay: firstDate,
                  lastDay: nowDate.add(const Duration(days: 30)),
                  focusedDay: _selectedDay!,
                  eventLoader: getEventsForDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: null,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    _onDaySelected(selectedDay, focusedDay);
                    provider.myTodoGet(selectedDay);
                  },
                  onPageChanged: (focusedDay) async {
                    _selectedDay = focusedDay;
                    await provider.getEventList(userProvider.user!.email!, focusedDay);
                    _selectedEvents = _getEventsForDay(_selectedDay!);
                    provider.myTodoGet(_selectedDay!);
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, events) {
                      final eventList = getEventsForDay(day);
                      if (eventList.contains('sunny')) {
                        return Positioned(
                          top: -14,
                          right: -6,
                          child: Image.asset(
                            'images/sunny.png',
                            width: 50,
                            height: 50,
                          ),
                        );
                      } else if (eventList.contains('cloud')) {
                        return Positioned(
                          top: -14,
                          right: -6,
                          child: Image.asset(
                            'images/cloud.png',
                            width: 40,
                            height: 40,
                          ),
                        );
                      } else if (eventList.contains('rain')) {
                        return Positioned(
                          top: -12,
                          right: -6,
                          child: Image.asset(
                            'images/rain.png',
                            width: 40,
                            height: 40,
                          ),
                        );
                      } else if (eventList.contains('snowy')) {
                        return Positioned(
                          top: -7,
                          right: -6,
                          // bottom: -10,
                          child: Image.asset(
                            'images/snowy.png',
                            width: 43,
                            height: 43,
                          ),
                        );
                      } else if (eventList.contains('rainning')) {
                        return Positioned(
                          top: -7,
                          right: -3,
                          // bottom: -10,
                          child: Image.asset(
                            'images/rainning.png',
                            width: 43,
                            height: 43,
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              ListView.builder(
                itemCount: _selectedEvents.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '오늘의 날씨',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                _selectedEvents[index].weather != ''
                                    ? Image.asset(
                                        'images/${_selectedEvents[index].weather}.png',
                                        width: 43,
                                        height: 43,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ],
                        ), // 아이콘으로 대체
                        const SizedBox(
                          height: 10,
                        ),
                        Text(_selectedEvents[index].mood),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: todoList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          value: todoList[index].checkTodo,
                          onChanged: (value) {
                            provider.myTodoUpdate(todoList[index].id, value!, _selectedDay!);
                            setState(() {});
                          },
                        ),
                        Expanded(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 500),
                            style: TextStyle(
                                decoration: todoList[index].checkTodo == true ? TextDecoration.lineThrough : null,
                                color: todoList[index].checkTodo == true
                                    ? Colors.grey
                                    : Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black87),
                            child: Text(
                              todoList[index].todoText.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        )),
      );
    });
  }
}
