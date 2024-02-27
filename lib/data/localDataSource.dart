import 'package:hive/hive.dart';
import 'package:my_diary/model/todo_model.dart';

class HiveLocalDataSource {
  Future<List<TodoModel>> myTodoGet(String selectedDayString) async {
    var myTodo = Hive.box<TodoModel>('myTodo').values.where((todo) => todo.date == selectedDayString).toList();
    return myTodo;
  }

  Future<List<TodoModel>> myTodoUpdate(int id, bool check, String selectedDayString) async {
    final box = await Hive.openBox<TodoModel>('myTodo');
    TodoModel? todo = box.get(id);
    todo = todo!.copyWith(checkTodo: check);
    box.put(id, todo);
    return myTodoGet(selectedDayString);
  }

  Future<void> myTodoSet() async {
    var myTodo = await Hive.box('myTodo');
  }

  Future<void> myTodoDelete() async {}
}
