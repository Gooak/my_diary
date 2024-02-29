import 'package:hive/hive.dart';
import 'package:my_diary/data/localDataSource.dart';
import 'package:my_diary/model/todo_model.dart';

class MyTodoForHive {
  final _dataSource = HiveLocalDataSource();

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
}