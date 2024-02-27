import 'package:hive/hive.dart';
import 'package:my_diary/data/localDataSource.dart';
import 'package:my_diary/model/todo_model.dart';

class MyTodoForHive {
  final _dataSource = HiveLocalDataSource();

  Future<List<TodoModel>> myTodoGet(String selectedDayString) async {
    return await _dataSource.myTodoGet(selectedDayString);
  }

  Future<List<TodoModel>> myTodoUpdate(int id, bool check, String selectedDayString) async {
    return await _dataSource.myTodoUpdate(id, check, selectedDayString);
  }

  Future<void> myTodoSet() async {
    await _dataSource.myTodoSet();
  }

  Future<void> myTodoDetele() async {
    await _dataSource.myTodoDelete();
  }
}
