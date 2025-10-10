import 'package:hive_flutter/adapters.dart';
import 'package:my_little_memory_diary/src/data/local/entity/todo_entity.dart';

class OpenHive {
  //Hive 오픈
  static Future<void> openHive() async {
    await Hive.initFlutter('my_diary_files');
    Hive.registerAdapter(TodoEntityAdapter());
    await Hive.openBox<TodoEntity>('myTodo');
    await Hive.openBox<int>('AppTheme');
    await Hive.openBox<int>('todoDayCount');
    await Hive.openBox<String>('todoTextColor');
  }
}
