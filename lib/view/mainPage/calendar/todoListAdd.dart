import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_little_memory_diary/common/googleAd.dart';
import 'package:my_little_memory_diary/common/googleFrontAd.dart';
import 'package:my_little_memory_diary/components/design.dart';
import 'package:my_little_memory_diary/components/snackBar.dart';
import 'package:my_little_memory_diary/model/todo_model.dart';
import 'package:my_little_memory_diary/viewModel/calendar_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TodoListAdd extends StatefulWidget {
  const TodoListAdd({
    super.key,
    this.date,
  });
  final DateTime? date;

  @override
  State<TodoListAdd> createState() => _TodoListAddState();
}

class _TodoListAddState extends State<TodoListAdd> {
  TextEditingController textController = TextEditingController();

  String? date = '날짜를 선택해주세요.';
  DateTime nowDate = DateTime.now();
  List<TodoModel> todoList = [];
  List<TodoModel> deleteTodoList = [];
  List<TodoModel> addTodoList = [];

  @override
  void initState() {
    super.initState();
    GoogleFrontAd.initialize();
    if (widget.date != null && !widget.date!.isBefore(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
      final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
      calendarProvider.myTodoGet(widget.date!);
      todoList = calendarProvider.todoList;
      date = DateFormat('yyyy-MM-dd').format(widget.date!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final calendarProvider = Provider.of<CalendarViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
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
          if (addTodoList.isEmpty && deleteTodoList.isEmpty) {
            showCustomSnackBar(context, '투두리스트를 작성해주세요!');
          } else {
            int count = todoList.length + addTodoList.length;
            if (addTodoList.isNotEmpty) {
              await calendarProvider.myTodoSet(addTodoList);
              calendarProvider.todoList.clear();
            }
            if (deleteTodoList.isNotEmpty) {
              await calendarProvider.myTodoDelete(deleteTodoList);
              calendarProvider.todoList.clear();
            }
            if (context.mounted) {
              if (date == '날짜를 선택해주세요.') {
                date = null;
              } else {
                final box = Hive.box<int>('todoDayCount');
                // box.put(date, TodoDayCountModel(date: date!, count: count));
                box.put(date, count);
              }
              Navigator.of(context).pop(date);
              GoogleFrontAd.loadInterstitialAd();
            }
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: size.width,
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
                    date!,
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
                  itemCount: todoList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
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
                          Expanded(
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 0.8,
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    value: todoList[index].checkTodo,
                                    onChanged: (value) {},
                                  ),
                                ),
                                Text(
                                  todoList[index].todoText.toString(),
                                  style: TextStyle(
                                      decoration: todoList[index].checkTodo == true ? TextDecoration.lineThrough : null,
                                      color: todoList[index].checkTodo == true ? Colors.grey : null),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteTodoList.add(todoList[index]);
                              todoList.remove(todoList[index]);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              if (date != '날짜를 선택해주세요.')
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: addTodoList.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index < addTodoList.length) {
                      return Column(
                        children: [
                          Container(
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
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Checkbox(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        value: addTodoList[index].checkTodo,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    Text(addTodoList[index].todoText.toString()),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteTodoList.add(todoList[index]);
                                    todoList.remove(todoList[index]);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete_forever),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ElevatedButton(
                          onPressed: () {
                            if (addTodoList.length + todoList.length == 10) {
                              showCustomSnackBar(context, '10개까지만 등록가능합니다!');
                            } else {
                              bottomSheet(context);
                            }
                          },
                          child: const Text('투두리스트 추가'));
                    }
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              const Text('※ 개인 핸드폰에 저장이 되며 앱 데이터 삭제시 같이 지워집니다. 앱 삭제하기전, 회원 관리에 투두리스트 백업을 해두시길 바랍니다.'),
              const SizedBox(
                height: 10,
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
      firstDate: nowDate,
      lastDate: nowDate.add(const Duration(days: 30)),
      locale: const Locale('ko', 'KO'),
    );
    selectedDate.then((selectedDay) async {
      if (selectedDay != null) {
        date = DateFormat('yyyy-MM-dd').format(selectedDay);
        addTodoList.clear();
        deleteTodoList.clear();
        await calendarProvider.myTodoGet(selectedDay);
        todoList = calendarProvider.todoList;
        setState(() {});
      }
    });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('할일 적기!'),
                const SizedBox(height: 20),
                TextField(
                  controller: textController,
                  maxLength: 20,
                  decoration: DesignInputDecoration(hintText: '할일을 적어주세요!', icon: null, circular: 5, hintCount: null).inputDecoration,
                ),
                ElevatedButton(
                  onPressed: () async {
                    addTodoList.add(TodoModel(id: -1, date: date!, todoText: textController.text, checkTodo: false, dateTime: nowDate));
                    setState(() {});
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text('추가하기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
