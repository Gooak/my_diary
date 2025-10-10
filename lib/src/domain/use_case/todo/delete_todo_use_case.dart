import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository _repository;
  DeleteTodoUseCase(this._repository);

  Future<void> deleteTodos(List<TodoModel> todo) async {
    return await _repository.deleteTodos(todo);
  }
}
