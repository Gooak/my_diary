import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository _repository;
  AddTodoUseCase(this._repository);

  Future<void> addTodo(List<TodoModel> todo) async {
    return await _repository.addTodo(todo);
  }
}
