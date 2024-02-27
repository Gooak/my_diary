import 'package:hive/hive.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
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

  TodoModel({
    required this.id,
    required this.date,
    required this.todoText,
    required this.checkTodo,
    required this.dateTime,
  });

  TodoModel copyWith({
    int? id,
    String? date,
    String? todoText,
    bool? checkTodo,
    DateTime? dateTime,
  }) {
    return TodoModel(
      id: id ?? this.id,
      date: date ?? this.date,
      todoText: todoText ?? this.todoText,
      checkTodo: checkTodo ?? this.checkTodo,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
