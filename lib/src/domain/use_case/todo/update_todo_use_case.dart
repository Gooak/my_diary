import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository _repository;
  UpdateTodoUseCase(this._repository);

  Future<void> updateTodo(int id, bool check) async {
    return await _repository.updateTodo(id, check);
  }

  Future<String> setTodoTextColor() async {
    return await _repository.setTodoTextColor();
  }
}
