import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_little_memory_diary/components/dialog.dart';
import 'package:my_little_memory_diary/model/calendar_model.dart';
import 'package:my_little_memory_diary/model/todo_model.dart';
import 'package:my_little_memory_diary/view/mainPage/calendar/calendarAdd.dart';
import 'package:my_little_memory_diary/view/mainPage/calendar/todoListAdd.dart';
import 'package:my_little_memory_diary/viewModel/calendar_view_model.dart';
import 'package:my_little_memory_diary/viewModel/user_view_model.dart';
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
  Map<DateTime, int> todos = {};

  List<TodoModel> todoList = [];

  String todoTextColor = '';

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
      return [eventsForDay[0].weather];
    } else {
      return []; // 이벤트가 없는 경우 null 반환
    }
  }

  List<String> getMoodForDay(DateTime day) {
    final List<CalendarModel> eventsForDay = events[day] ?? [];

    if (eventsForDay.isNotEmpty) {
      return [eventsForDay[0].moodImage];
    } else {
      return []; // 이벤트가 없는 경우 null 반환
    }
  }

  List<int> getTodoCountForDay(DateTime day) {
    final todoCount = todos[day] ?? 0;

    if (todoCount > 0) {
      return [todoCount];
    } else {
      return []; // 이벤트가 없는 경우 null 반환
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CalendarViewModel>(context, listen: false).myTodoGet(nowDate);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    checkDate = DateTime.utc(nowDate.year, nowDate.month, nowDate.day);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
    firstDate = userProvider.joinDate;
    _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    calendarProvider.getEventList(userProvider.user!.email.toString(), nowDate, countCheck: true, firstFun: true);
    calendarProvider.myTodoDayCountGet(nowDate);
    await calendarProvider.myTodoTextColorGet();
    await calendarProvider.myTodoHomeWidget();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CalendarViewModel>(builder: (context, provider, child) {
      _selectedEvents = _getEventsForDay(_selectedDay!);
      events = provider.events;
      todoList = provider.todoList;
      todos = provider.todos;
      todoTextColor = provider.todoTextColor;
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
                    builder: (context) => TodoListAdd(date: _selectedDay!),
                  ),
                );
                if (date != null) {
                  if (DateFormat('yyyy-MM-dd').format(_selectedDay!) == date) {
                    provider.myTodoGet(_selectedDay!);
                    provider.myTodoHomeWidget();
                  }
                  provider.myTodoDayCountGet(_selectedDay!);
                }
              },
            ),
            // SpeedDialChild(
            //   child: const Text('통계'),
            //   onTap: () async {
            //     if (provider.eventChart != null) {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarChart(eventChart: provider.eventChart!)));
            //     } else {
            //       showCustomSnackBar(context, '이번 달에 작성하신 일기가 없습니다.');
            //     }
            //   },
            // ),
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
                  // eventLoader: getEventsForDay,
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
                      fontWeight: FontWeight.bold,
                    ),
                    todayDecoration: const BoxDecoration(
                      color: null,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    _onDaySelected(selectedDay, focusedDay);
                    provider.myTodoGet(selectedDay);
                  },
                  onPageChanged: (focusedDay) async {
                    _selectedDay = focusedDay;
                    await provider.getEventList(
                      userProvider.user!.email!,
                      focusedDay,
                    );
                    await provider.myTodoDayCountGet(
                      focusedDay,
                    );
                    _selectedEvents = _getEventsForDay(_selectedDay!);
                    provider.myTodoGet(_selectedDay!);
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, day, _) {
                      final todoList = getTodoCountForDay(day);
                      final eventList = getEventsForDay(day);
                      final moodList = getMoodForDay(day);
                      if (eventList.contains('sunny')) {
                        return Stack(
                          children: [
                            Positioned(
                              top: -3,
                              right: -2,
                              child: Image.asset(
                                'images/sunny.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            if (todoList.isNotEmpty)
                              Positioned(
                                bottom: 6,
                                right: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSecondary
                                        : Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      todoList.first.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            if (moodList.isNotEmpty)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/${moodList[0]}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                          ],
                        );
                      } else if (eventList.contains('cloud')) {
                        return Stack(
                          children: [
                            Positioned(
                              top: -11,
                              right: -3,
                              child: Image.asset(
                                'images/cloud.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            if (todoList.isNotEmpty)
                              Positioned(
                                bottom: 6,
                                right: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSecondary
                                        : Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      todoList.first.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            if (moodList.isNotEmpty)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/${moodList[0]}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                          ],
                        );
                      } else if (eventList.contains('rain')) {
                        return Stack(
                          children: [
                            Positioned(
                              top: -11,
                              right: -3,
                              child: Image.asset(
                                'images/rain.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            if (todoList.isNotEmpty)
                              Positioned(
                                bottom: 6,
                                right: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSecondary
                                        : Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      todoList.first.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            if (moodList.isNotEmpty)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/${moodList[0]}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                          ],
                        );
                      } else if (eventList.contains('snowy')) {
                        return Stack(
                          children: [
                            Positioned(
                              top: -3,
                              right: -3,
                              child: Image.asset(
                                'images/snowy.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            if (todoList.isNotEmpty)
                              Positioned(
                                bottom: 6,
                                right: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSecondary
                                        : Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      todoList.first.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            if (moodList.isNotEmpty)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/${moodList[0]}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                          ],
                        );
                      } else if (eventList.contains('rainning')) {
                        return Stack(
                          children: [
                            Positioned(
                              top: -8,
                              right: -3,
                              child: Image.asset(
                                'images/rainning.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                            if (todoList.isNotEmpty)
                              Positioned(
                                bottom: 6,
                                right: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Theme.of(context).colorScheme.onSecondary
                                        : Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Center(
                                    child: Text(
                                      todoList.first.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            if (moodList.isNotEmpty)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'images/${moodList[0]}.png',
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                          ],
                        );
                      } else if (todoList.isNotEmpty) {
                        return Positioned(
                          bottom: 6,
                          right: 2,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.3, color: Colors.black),
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.onSecondary
                                  : Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Center(
                              child: Text(
                                todoList.first.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
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
                                    ? ExtendedImage.asset(
                                        'images/${_selectedEvents[index].weather}.png',
                                        width: 43,
                                        height: 43,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                            if (_selectedEvents[index].moodImage != '')
                              ExtendedImage.asset(
                                'images/${_selectedEvents[index].moodImage}.png',
                                width: 43,
                                height: 43,
                              )
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
              if (todoList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Row(
                        children: [
                          const Text('투두리스트'),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await provider.myTodoTextColorSet();
                            },
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                color: todoTextColor == '0' ? Colors.grey : Colors.black,
                              ),
                              child: Text(todoTextColor == '0' ? 'White' : 'Black'),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              dialogFunc(
                                  context: context,
                                  title: '도움말',
                                  text: '홈 위젯의 글자 색상을 바꿉니다.\n(흰색, 검은색)',
                                  cancel: '',
                                  enter: '확인',
                                  cancelAction: () {},
                                  enterAction: () {
                                    Navigator.pop(context);
                                  });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.question_mark_rounded,
                                  size: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Checkbox(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  value: todoList[index].checkTodo,
                                  onChanged: (value) {
                                    provider.myTodoUpdate(todoList[index].id, value!, _selectedDay!);
                                    provider.myTodoHomeWidget(currentPageDate: DateFormat('yyyy-MM-dd').format(_selectedDay!));
                                    setState(() {});
                                  },
                                ),
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                      child: Text('홈 위젯 글자 색상 변경'),
                    ),
                  ],
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
