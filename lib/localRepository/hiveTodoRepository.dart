import 'package:hive/hive.dart';
import 'package:my_little_memory_diary/data/todoLocalDataSource.dart';
import 'package:my_little_memory_diary/model/todo_model.dart';

class MyTodoForHive {
  final _dataSource = HiveLocalDataSource();

  Future<int> myTodoAllGet() async {
    return await _dataSource.myTodoAllGet();
  }

  Future<int> myTodoAllActiveGet() async {
    return await _dataSource.myTodoAllActiveGet();
  }

  Future<List<TodoModel>> myTodoGet(String selectedDayString) async {
    return await _dataSource.myTodoGet(selectedDayString);
  }

  Future<void> myTodoSet(List<TodoModel> addTodoList) async {
    await _dataSource.myTodoSet(addTodoList);
  }

  Future<List<TodoModel>> myTodoUpdate(int id, bool check, String selectedDayString) async {
    return await _dataSource.myTodoUpdate(id, check, selectedDayString);
  }

  Future<void> myTodoDelete(List<TodoModel> deleteTodoList) async {
    await _dataSource.myTodoDelete(deleteTodoList);
  }

  Future<String> myTodoTextColorGet() async {
    return _dataSource.myTodoTextColorGet();
  }

  Future<String> myTodoTextColorSet() async {
    return _dataSource.myTodoTextColorSet();
  }
}
