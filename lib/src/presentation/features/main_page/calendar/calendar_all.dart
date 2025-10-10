import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';

class CalendarAll extends ConsumerStatefulWidget {
  const CalendarAll({super.key});

  @override
  ConsumerState<CalendarAll> createState() => _CalendarAllState();
}

class _CalendarAllState extends ConsumerState<CalendarAll> {
  bool sort = false;
  List<CalendarModel> eventList = [];

  @override
  void initState() {
    super.initState();
    // final user = ref.read(userProvider);
    // ref.read(calendarProvider).getEventAllList(user.user!.email!, sort);
  }

  @override
  Widget build(BuildContext context) {
    // eventList = ref.read(calendarProvider).eventList;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '모아보기',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                sort = !sort;
              });
            },
            icon:
                Icon(sort == false ? Icons.arrow_downward : Icons.arrow_upward),
          ),
        ],
        elevation: 0,
      ),
      body: buildListView(context, eventList),
    );
  }
}

Widget buildListView(BuildContext context, List<CalendarModel> eventList) {
  return eventList.isEmpty
      ? const Center(
          child: Text('오늘 하루의 기분을 입력해주세요'),
        )
      : ListView.builder(
          itemCount: eventList.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Row(
                children: [
                  Text(
                    eventList[index].date,
                    style: const TextStyle(
                      color: Color(0xFF7D5260),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  eventList[index].weather != ''
                      ? Image.asset(
                          'images/${eventList[index].weather}.png',
                          width: 43,
                          height: 43,
                        )
                      : const SizedBox.shrink()
                ],
              ),
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 15, 5, 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(eventList[index].mood.toString()),
                    ],
                  ),
                ),
              ],
            );
          },
        );
}
