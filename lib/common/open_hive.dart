import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_little_memory_diary/model/todo_model.dart';

class OpenHive {
  static Future<void> openHive() async {
    await Hive.initFlutter('my_diary_files');
    Hive.registerAdapter(TodoModelAdapter());
    await Hive.openBox<TodoModel>('myTodo');
    await Hive.openBox<int>('AppTheme');
    await Hive.openBox<int>('todoDayCount');
    await Hive.openBox<String>('todoTextColor');
  }
}
