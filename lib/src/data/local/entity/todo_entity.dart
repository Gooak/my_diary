import 'package:hive/hive.dart';
import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
part 'todo_entity.g.dart';

@HiveType(typeId: 0)
class TodoEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String todoText;

  @HiveField(3)
  final bool checkTodo;

  @HiveField(4)
  final DateTime dateTime;

  TodoEntity({
    required this.id,
    required this.date,
    required this.todoText,
    required this.checkTodo,
    required this.dateTime,
  });

  TodoEntity copyWith({
    int? id,
    String? date,
    String? todoText,
    bool? checkTodo,
    DateTime? dateTime,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      todoText: todoText ?? this.todoText,
      checkTodo: checkTodo ?? this.checkTodo,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  TodoModel toModel() {
    return TodoModel(
      id: id,
      date: date,
      todoText: todoText,
      checkTodo: checkTodo,
      dateTime: dateTime,
    );
  }
}
