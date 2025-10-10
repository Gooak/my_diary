import 'package:my_little_memory_diary/src/data/local/entity/todo_entity.dart';

class TodoModel {
  int id;
  String date;
  String todoText;
  bool checkTodo;
  DateTime dateTime;

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

  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      date: date,
      todoText: todoText,
      checkTodo: checkTodo,
      dateTime: dateTime,
    );
  }
}
