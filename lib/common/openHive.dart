import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_diary/model/todo_model.dart';

class OpenHive {
  static Future<void> openHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoModelAdapter());
    await Hive.openBox<TodoModel>('myTodo');
  }
}