import 'package:hive/hive.dart';
import 'package:my_diary/model/todo_model.dart';

class HiveLocalDataSource {
  Future<int> myTodoAllGet() async {
    var myTodo = Hive.box<TodoModel>('myTodo').values.toList();
    return myTodo.length;
  }

  Future<int> myTodoAllActiveGet() async {
    var myTodo = Hive.box<TodoModel>('myTodo').values.where((todo) => todo.checkTodo == true).toList();
    return myTodo.length;
  }

  Future<List<TodoModel>> myTodoGet(String selectedDayString) async {
    var myTodo = Hive.box<TodoModel>('myTodo').values.where((todo) => todo.date == selectedDayString).toList();
    return myTodo;
  }

  Future<void> myTodoSet(List<TodoModel> addTodoList) async {
    final box = await Hive.openBox<TodoModel>('myTodo');
    int id = 0;
    if (box.isNotEmpty) {
      final item = box.getAt(box.length - 1);

      if (item != null) {
        id = item.id + 1;
      }
    }
    for (var todo in addTodoList) {
      todo = todo.copyWith(id: id);
      box.put(id, todo);
      id += 1;
    }
  }

  Future<List<TodoModel>> myTodoUpdate(int id, bool check, String selectedDayString) async {
    final box = await Hive.openBox<TodoModel>('myTodo');
    TodoModel? todo = box.get(id);
    todo = todo!.copyWith(checkTodo: check);
    box.put(id, todo);
    return myTodoGet(selectedDayString);
  }

  Future<void> myTodoDelete(List<TodoModel> deleteTodoList) async {
    final box = await Hive.openBox<TodoModel>('myTodo');

    for (var todo in deleteTodoList) {
      box.delete(todo.id);
    }
  }
}
