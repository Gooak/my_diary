import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_little_memory_diary/src/enum/mood_enum.dart';
import 'package:my_little_memory_diary/src/enum/weather_enum.dart';
import 'package:my_little_memory_diary/src/core/utils/date_helper.dart';
import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/presentation/common/widgets/dialog.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/calendar/calendar_add.dart';
import 'package:my_little_memory_diary/src/presentation/features/main_page/calendar/todo_list_add.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/calendar_notifier.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/todo_notifier.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/calendar_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/todo_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MyCalendar extends ConsumerStatefulWidget {
  const MyCalendar({super.key});

  @override
  ConsumerState<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends ConsumerState<MyCalendar> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoNotifierProvider);
    final todoNotifier = ref.watch(todoNotifierProvider.notifier);
    final calendarNotifier = ref.watch(calendarNotifierProvider.notifier);
    ref.watch(calendarNotifierProvider);

    return Scaffold(
      floatingActionButton: SpeedDial(
        heroTag: 'CalendarAdd',
        animatedIcon: AnimatedIcons.menu_close,
        useRotationAnimation: true,
        animationCurve: Curves.elasticInOut,
        children: [
          SpeedDialChild(
            child: const Text('Todo'),
            onTap: () async {
              final todoSaveFunctions = ref.read(todoNotifierProvider.notifier);

              String? date = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoListAdd(date: _selectedDay),
                ),
              );
              if (!mounted) return;

              if (date != null) {
                if (DateHelper.toStringDateFromDateTime(_selectedDay) == date) {
                  todoSaveFunctions.getTodosByDate(_selectedDay);
                  todoSaveFunctions.buildTodoHomeWidget(_selectedDay);
                }
              }
            },
          ),
          if (_selectedDay.isBefore(DateTime.now()) == true)
            SpeedDialChild(
              child: const Text('Today'),
              onTap: () async {
                final calendarSaveFunctions =
                    ref.read(calendarNotifierProvider.notifier);
                DateTime? date = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarAdd(
                        selectedDay: _selectedDay,
                        event: calendarNotifier.eventViewItem),
                  ),
                );
                if (!mounted) return;

                if (date != null) {
                  calendarSaveFunctions.getEventByDate(date);
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
            _calendarWidget(calendarNotifier, todoNotifier),
            _eventView(calendarNotifier),
            todoList.when(
              data: (todoList) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _todoTitle(todoNotifier),
                    ListView.builder(
                      itemCount: todoList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _todoListItem(todoList[index], todoNotifier);
                      },
                    ),
                  ],
                );
              },
              error: (e, st) => Center(child: Text('일시적인 오류가 발생했습니다.')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      )),
    );
  }

  //캘린더 위젯
  Widget _calendarWidget(
      CalendarNotifier calendarNotifier, TodoNotifier todoNotifier) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final user = ref.watch(userNotifierProvider).value;

    if (calendarState.isLoading || user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    calendarNotifier.getEventViewForDay(_selectedDay);

    return TableCalendar(
      onFormatChanged: (format) {
        return;
      },
      daysOfWeekHeight: 50,
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      locale: 'ko_KR', // 추가
      firstDay: user.joinDate!.toDate(),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: _selectedDay,
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
      eventLoader: (_) {
        calendarNotifier.getEventViewForDay(_selectedDay);
        return [];
      },
      onDaySelected: (selectedDay, focusedDay) async {
        _selectedDay = selectedDay;
        await calendarNotifier.getEventViewForDay(selectedDay);
        todoNotifier.getTodosByDate(selectedDay);
      },
      onPageChanged: (focusedDay) async {
        _selectedDay = focusedDay;
        // 일기 조회
        await calendarNotifier.getEnvetsForPageChanged(_selectedDay);
        //일기 뷰 조회
        await calendarNotifier.getEventViewForDay(_selectedDay);

        // 투두리스트 조회
        todoNotifier.getTodosByDate(_selectedDay);
        await todoNotifier.getTodoListCount(_selectedDay);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, _) {
          final CalendarModel? event = calendarNotifier.getEventsForDay(day);
          final int? todoCountDay = todoNotifier.getTodoCountForDay(day);
          return Stack(
            children: [
              if (event != null) ...[
                _weatherToCalendarMaker(event.weather),
                _moodToCalendarMaker(event.moodImage),
              ],
              if (todoCountDay != null) _todoCountToCalendarMaker(todoCountDay)
            ],
          );
        },
      ),
    );
  }

  // 이벤트 뷰
  Widget _eventView(CalendarNotifier calendarNotifier) {
    return calendarNotifier.eventViewItem == null
        ? const SizedBox.shrink()
        : Container(
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
                        ExtendedImage.asset(
                          'images/${calendarNotifier.eventViewItem!.weather}.png',
                          width: 43,
                          height: 43,
                        )
                      ],
                    ),
                    ExtendedImage.asset(
                      'images/${calendarNotifier.eventViewItem!.moodImage}.png',
                      width: 43,
                      height: 43,
                    )
                  ],
                ), // 아이콘으로 대체
                const SizedBox(
                  height: 10,
                ),
                Text(calendarNotifier.eventViewItem!.mood),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
  }

  //투두리스트 상단 타이틀
  Widget _todoTitle(TodoNotifier todoNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
      child: Row(
        children: [
          const Text('투두리스트'),
          const SizedBox(
            width: 10,
          ),
          OutlinedButton(
            onPressed: () async {
              todoNotifier.setTodoTextColor();
              setState(() {});
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: todoNotifier.homeWidgetTextColor == '0'
                    ? Colors.grey
                    : Colors.black,
              ),
              child: Text(
                  todoNotifier.homeWidgetTextColor == '0' ? 'White' : 'Black'),
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
    );
  }

  //투두리스트 아이템
  Widget _todoListItem(TodoModel todoItem, TodoNotifier todoNotifier) {
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              value: todoItem.checkTodo,
              onChanged: (value) async {
                todoItem.checkTodo = value!;
                await todoNotifier.updateTodo(todoItem.id, value);
                await todoNotifier.buildTodoHomeWidget(_selectedDay);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              style: TextStyle(
                  decoration: todoItem.checkTodo == true
                      ? TextDecoration.lineThrough
                      : null,
                  color: todoItem.checkTodo == true
                      ? Colors.grey
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87),
              child: Text(
                todoItem.todoText.toString(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //날씨 아이콘
  Positioned _weatherToCalendarMaker(String weatherName) {
    WeatherEnum weather = WeatherEnum.fromName(weatherName);
    return Positioned(
      top: weather.top,
      right: weather.right,
      child: Image.asset(
        weather.path,
        width: weather.width,
        height: weather.height,
      ),
    );
  }

  //기분
  Positioned _moodToCalendarMaker(String moodName) {
    MoodEnum mood = MoodEnum.fromName(moodName);
    return Positioned(
      left: mood.left,
      bottom: mood.bottom,
      child: Image.asset(
        mood.path,
        width: mood.width,
        height: mood.height,
      ),
    );
  }

  //투두리스트 개수
  Positioned _todoCountToCalendarMaker(int todoCount) {
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
            "$todoCount",
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
