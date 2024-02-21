import 'package:flutter/material.dart';
import 'package:my_diary/model/calendar_model.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class CalendarAll extends StatefulWidget {
  const CalendarAll({super.key});

  @override
  State<CalendarAll> createState() => _CalendarAllState();
}

class _CalendarAllState extends State<CalendarAll> {
  bool sort = false;
  List<CalendarModel> eventList = [];
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Consumer<CalendarViewModel>(builder: (context, provider, child) {
      provider.getEventAllList(userProvider.user!.email!, sort);
      eventList = provider.eventList;
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
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
              icon: Icon(sort == false ? Icons.arrow_downward : Icons.arrow_upward),
            ),
          ],
          elevation: 0,
        ),
        body: buildListView(context, eventList),
      );
    });
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
}
