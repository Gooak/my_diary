import 'package:flutter/material.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/model/calendar_model.dart';
import 'package:my_diary/view/mainPage/calendar/calendarAdd.dart';
import 'package:my_diary/view/mainPage/calendar/calendarAll.dart';
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
    firstDate = userProvider.joinDate;
    _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    Provider.of<CalendarViewModel>(context, listen: false).getEventList(userProvider.user!.email.toString(), nowDate);
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
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: 'CalendarAdd',
          onPressed: () async {
            if (events[checkDate]!.isEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarAdd(),
                ),
              );
            } else {
              showCustomSnackBar(context, '오늘 이미 작성하셨습니다!');
            }
          },
          child: const Icon(Icons.add),
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
                  lastDay: nowDate,
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
                    selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
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
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) async {
                    _selectedDay = focusedDay;
                    await provider.getEventList(userProvider.user!.email!, focusedDay);
                    _selectedEvents = _getEventsForDay(_selectedDay!);
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
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 8, 15, 15),
              //   child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => const CalendarAll(),
              //           ),
              //         );
              //       },
              //       child: const Text('모아보기')),
              // ),
            ],
          ),
        )),
      );
    });
  }
}
