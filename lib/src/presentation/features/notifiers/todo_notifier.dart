import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:my_little_memory_diary/src/core/utils/date_helper.dart';
import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/todo_provider.dart';

class TodoNotifier extends AsyncNotifier<List<TodoModel>> {
  DateTime date = DateTime.now();

  final DateFormat format = DateFormat('yyyy-MM-dd');

  Map<DateTime, int> _todo = {};

  String _homeWidgetTextColor = '0';
  String get homeWidgetTextColor => _homeWidgetTextColor;

  int todoCount = 0;
  int activeTodoCount = 0;

  @override
  Future<List<TodoModel>> build() async {
    await getTodoTextColor();
    await buildTodoHomeWidget(date);
    await getTodoListCount(date);
    await getTodoAllCount();
    final formatted = format.format(date);
    return await ref.read(getTodoUseCaseProvider).getTodosByDate(formatted);
  }

  // todo 가져오기
  Future<void> getTodosByDate(DateTime selectedDay) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final formatted = format.format(selectedDay);
      return await ref.read(getTodoUseCaseProvider).getTodosByDate(formatted);
    });
  }

  // todo 총 개수 가져오기
  Future<void> getTodoAllCount() async {
    List<TodoModel> todoItems =
        await ref.read(getTodoUseCaseProvider).getTodoList();

    activeTodoCount = todoItems.where((e) => e.checkTodo == true).length;
    todoCount = todoItems.length;
  }

  // todo_list_add용
  Future<List<TodoModel>> getTodosByDateAddPage(DateTime selectedDay) async {
    final formatted = format.format(selectedDay);
    return await ref.read(getTodoUseCaseProvider).getTodosByDate(formatted);
  }

  // todo 업데이트
  Future<void> addTodo(List<TodoModel> todo) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      await ref.read(addTodoUseCaseProvider).addTodo(todo);
      await getTodoAllCount();
      ref.invalidateSelf();
    });
  }

  // todo 업데이트
  Future<void> updateTodo(int id, bool check) async {
    final currentState = state.value;
    if (currentState == null) return;

    final newList = currentState.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(checkTodo: check);
      }
      return todo;
    }).toList();

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateTodoUseCaseProvider).updateTodo(id, check);
      await getTodoAllCount();
      return newList;
    });
  }

  //todo 삭제
  Future<void> deleteTodo(List<TodoModel> todo) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
      ref.read(deleteTodoUseCaseProvider).deleteTodos(todo);
      await getTodoAllCount();
      ref.invalidateSelf();
    });
  }

  //todo 개수 가져오는 함수
  Future getTodoListCount(DateTime selectedDay) async {
    final formatted = DateFormat('yyyy-MM').format(selectedDay);
    List<TodoModel> allTodosForMonth =
        await ref.read(getTodoUseCaseProvider).getTodosByDate(formatted);

    final Map<DateTime, int> todoCounts = {};

    for (final todo in allTodosForMonth) {
      try {
        final dateKey = DateHelper.toDateKeyFromString(todo.date);
        todoCounts.update(dateKey, (count) => count + 1, ifAbsent: () => 1);
      } catch (e) {
        continue;
      }
    }
    _todo = todoCounts;
  }

  // 해당 날짜 todo 개수
  int? getTodoCountForDay(DateTime day) {
    if (_todo.isNotEmpty) {
      final todoCount = _todo[day] ?? 0;

      if (todoCount > 0) {
        return todoCount;
      } else {
        return null;
      }
    }
    return null;
  }

  //투두 색상 가져오기
  Future<void> getTodoTextColor() async {
    _homeWidgetTextColor =
        await ref.read(getTodoUseCaseProvider).getTodoTextColor();
  }

  //투두 색상 변경
  Future<void> setTodoTextColor() async {
    _homeWidgetTextColor =
        await ref.read(updateTodoUseCaseProvider).setTodoTextColor();
    await HomeWidget.saveWidgetData<String>(
        'todoTextColor', _homeWidgetTextColor);
    await HomeWidget.updateWidget(
        name: 'HomeWidgetProvider', iOSName: 'HomeWidgetProvider');
  }

  //홈위젯 투두 추가
  Future<void> buildTodoHomeWidget(DateTime selectedDay) async {
    final formatted = format.format(selectedDay);
    final todoHomeWidget =
        await ref.read(getTodoUseCaseProvider).getTodosByDate(formatted);

    String todoText = '';
    if (todoHomeWidget.isNotEmpty) {
      todoText = '${todoHomeWidget[0].date} 투두리스트\n';
      for (var todoItem in todoHomeWidget) {
        todoText +=
            '${todoItem.todoText} ${todoItem.checkTodo == true ? "✔️" : "❌"}\n';
      }
    }
    await HomeWidget.saveWidgetData<String>(
        'todoTextColor', _homeWidgetTextColor);
    await HomeWidget.saveWidgetData<String>('todoList', todoText);
    await HomeWidget.updateWidget(
        name: 'HomeWidgetProvider', iOSName: 'HomeWidgetProvider');
  }
}
