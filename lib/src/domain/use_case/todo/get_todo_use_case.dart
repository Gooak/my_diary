import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';

class GetTodoUseCase {
  final TodoRepository _repository;
  GetTodoUseCase(this._repository);

  Future<List<TodoModel>> getTodoList() async {
    return await _repository.getTodoList();
  }

  Future<List<TodoModel>> getTodosByDate(String selectedDayString) async {
    return await _repository.getTodosByDate(selectedDayString);
  }

  Future<String> getTodoTextColor() async {
    return await _repository.getTodoTextColor();
  }
}
