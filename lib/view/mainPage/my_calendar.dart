import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/model/calendar_model.dart';
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

  Map<DateTime, List<CalendarModel>> events = {};
  String weather = '';
  String mood = '';

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
    firstDate = Provider.of<UserProvider>(context, listen: false).joinDate;
    _selectedDay = DateTime.utc(_focusedDay.year, _focusedDay.month, _focusedDay.day);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CalendarViewModel>(builder: (context, provider, child) {
      provider.getEventList(userProvider.user!.email.toString(), nowDate);
      _selectedEvents = _getEventsForDay(_selectedDay!);
      events = provider.events;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
            await provider.setEvent(
                userProvider.user!.email!, date, CalendarModel(date: date, weather: 'cloud', mood: '기분', timestamp: Timestamp.now()));
          },
          child: const Icon(Icons.post_add_rounded),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
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
                  lastDay: nowDate.add(const Duration(days: 90)),
                  focusedDay: _selectedDay!,
                  eventLoader: getEventsForDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  calendarStyle: const CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFFE8DEF8),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Color(0xFF7D5260),
                    ),
                    todayDecoration: BoxDecoration(
                      color: null,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Color(0xFF7D5260),
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
                        color: const Color(0xFFFFD8E4),
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
                                const Text(
                                  '오늘의 날씨!! ',
                                  style: TextStyle(
                                    color: Color(0xFF7D5260),
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
                            ElevatedButton(
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarListView()));
                                },
                                child: const Text('모아보기')),
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
            ],
          ),
        )),
      );
    });
  }

  // void inputCalendar(String checkWeather, EventViewModel provider) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setState) {
  //         return AlertDialog(
  //           title: const Text(
  //             '오늘 하고싶은 말을 적어줘!(15자)',
  //             style: TextStyle(fontSize: 16),
  //           ),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               if (checkWeather == '')
  //                 Wrap(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           weather = 'sunny';
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(color: weather == 'sunny' ? Colors.white : null, borderRadius: BorderRadius.circular(70)),
  //                         child: Center(
  //                           child: Image.asset(
  //                             'images/sunny.png',
  //                             width: 50,
  //                             height: 50,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           weather = 'cloud';
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(color: weather == 'cloud' ? Colors.white : null, borderRadius: BorderRadius.circular(70)),
  //                         child: Center(
  //                           child: Image.asset(
  //                             'images/cloud.png',
  //                             width: 50,
  //                             height: 50,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           weather = 'snowy';
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(color: weather == 'snowy' ? Colors.white : null, borderRadius: BorderRadius.circular(70)),
  //                         child: Center(
  //                           child: Image.asset(
  //                             'images/snowy.png',
  //                             width: 50,
  //                             height: 50,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           weather = 'rain';
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(color: weather == 'rain' ? Colors.white : null, borderRadius: BorderRadius.circular(70)),
  //                         child: Center(
  //                           child: Image.asset(
  //                             'images/rain.png',
  //                             width: 50,
  //                             height: 50,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           weather = 'rainning';
  //                         });
  //                       },
  //                       child: Container(
  //                         width: 70,
  //                         height: 70,
  //                         decoration: BoxDecoration(color: weather == 'rainning' ? Colors.white : null, borderRadius: BorderRadius.circular(70)),
  //                         child: Center(
  //                           child: Image.asset(
  //                             'images/rainning.png',
  //                             width: 50,
  //                             height: 50,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               const SizedBox(
  //                 height: 15,
  //               ),
  //               TextField(
  //                 maxLength: 15,
  //                 controller: textController,
  //                 decoration: InputDecoration(
  //                   counterText: '',
  //                   prefixIcon: const Icon(Icons.content_copy_outlined),
  //                   fillColor: Colors.white,
  //                   filled: true,
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(5),
  //                     borderSide: const BorderSide(color: Colors.grey, width: 1),
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(5),
  //                     borderSide: const BorderSide(color: Colors.grey, width: 1),
  //                   ),
  //                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: Colors.grey, width: 1)),
  //                   focusedErrorBorder: const OutlineInputBorder(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () async {
  //                   if (_selectedEvents.isNotEmpty) {
  //                     weather = _selectedEvents[0].weather;
  //                     if (_selectedEvents[0].firstEmail == Provider.of<UserProvider>(context, listen: false).email) {
  //                       FunctionList().toast('이미 글을 작성하셨습니다..');
  //                       return;
  //                     }
  //                   }
  //                   if (weather == '') {
  //                     FunctionList().toast('날씨를 선택해줘!');
  //                     return;
  //                   }
  //                   if (textController.text.isEmpty) {
  //                     FunctionList().toast('글을 작성해주세요.');
  //                     return;
  //                   } else {
  //                     final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //                     final inputCal = FirebaseFirestore.instance.collection('Calendar');

  //                     await inputCal.doc(date).get().then((doc) {
  //                       if (doc.exists) {
  //                         inputCal.doc(date).update({
  //                           'second': '${Provider.of<UserProvider>(context, listen: false).userName} : ${textController.text}',
  //                           'secondEmail': Provider.of<UserProvider>(context, listen: false).email,
  //                           'secondMood': mood,
  //                         });
  //                       } else {
  //                         inputCal.doc(date).set({
  //                           'Date': date,
  //                           'weather': weather,
  //                           'first': '${Provider.of<UserProvider>(context, listen: false).userName} : ${textController.text}',
  //                           'second': '',
  //                           'firstEmail': Provider.of<UserProvider>(context, listen: false).email,
  //                           'secondEmail': '',
  //                           'firstMood': mood,
  //                           'secondMood': '',
  //                           'timestamp': Timestamp.now(),
  //                         });
  //                       }
  //                     });
  //                     mood = '';
  //                     weather = '';
  //                     textController.text = '';
  //                     Navigator.pop(context);
  //                     provider.getEventList(nowDate);
  //                   }
  //                 },
  //                 child: const Text('쓰기')),
  //             TextButton(
  //                 onPressed: () {
  //                   mood = '';
  //                   weather = '';
  //                   textController.text = '';
  //                   Navigator.pop(context);
  //                 },
  //                 child: const Text('뒤로가기'))
  //           ],
  //         );
  //       });
  //     },
  //   );
  // }
}
