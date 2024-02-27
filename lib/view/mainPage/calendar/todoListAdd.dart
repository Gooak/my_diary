import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_diary/common/googleAd.dart';
import 'package:my_diary/common/googleFrontAd.dart';
import 'package:my_diary/components/design.dart';
import 'package:my_diary/model/todo_model.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoListAdd extends StatefulWidget {
  const TodoListAdd({super.key});

  @override
  State<TodoListAdd> createState() => _TodoListAddState();
}

class _TodoListAddState extends State<TodoListAdd> {
  String date = '날짜를 선택해주세요.';
  List<TodoModel> todoList = [];

  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '투두리스트 작성',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'CalendarAdd',
        onPressed: () async {
          await GoogleFrontAd.initialize();
          if (context.mounted) {
            Navigator.pop(context);
            GoogleFrontAd.loadInterstitialAd();
          }
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 5,
            ),
            Text('저장')
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('날짜 선택'),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  showDatePickerPop(context, calendarProvider);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  width: size.width,
                  child: Text(
                    date,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('투두리스트'),
              const SizedBox(
                height: 5,
              ),
              if (date != '날짜를 선택해주세요.')
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: todoList.length + 1 > 10 ? 10 : todoList.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < todoList.length) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(todoList[index].todoText.toString()),
                            Checkbox(
                              value: todoList[index].checkTodo,
                              onChanged: (value) {},
                            )
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: size.width,
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              bottomSheet();
                            },
                            child: const Text('투두리스트 추가'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              const GoogleAd(),
            ],
          ),
        ),
      ),
    );
  }

  void showDatePickerPop(BuildContext context, CalendarViewModel calendarProvider) {
    Future<DateTime?> selectedDate = showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('ko', 'KO'),
    );
    selectedDate.then((selectedDay) async {
      if (selectedDay != null) {
        date = "${selectedDay.year.toString()}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
        await calendarProvider.myTodoGet(selectedDay);
        todoList = calendarProvider.todoList;
        setState(() {});
      }
    });
  }

  void bottomSheet() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          child: Column(
            children: [
              const Text('할일 적기!'),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _textController,
                decoration: DesignInputDecoration(hintText: '할일을 적어주세요!', icon: null, circular: 5, hintCount: null).inputDecoration,
              ),
              TextButton(onPressed: () {}, child: Text('추가하기')),
            ],
          ),
        );
      },
    );
  }
}
