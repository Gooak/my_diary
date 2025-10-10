import 'package:my_little_memory_diary/src/data/local_data_source/todo_data_source.dart';
import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDataSource _dataSource;
  TodoRepositoryImpl(this._dataSource);

  // 투두리스트 가져오기
  @override
  Future<List<TodoModel>> getTodoList() async {
    return (await _dataSource.getTodoList()).map((e) => e.toModel()).toList();
  }

  // 특정 날짜 투두리스트
  @override
  Future<List<TodoModel>> getTodosByDate(String selectedDayString) async {
    return (await _dataSource.getTodosByDate(selectedDayString))
        .map((e) => e.toModel())
        .toList();
  }

  //투두리스트 저장
  @override
  Future<void> addTodo(List<TodoModel> addTodoList) async {
    await _dataSource.addTodo(addTodoList.map((e) => e.toEntity()).toList());
  }

  //투두리스트 업데이트
  @override
  Future<void> updateTodo(int id, bool check) async {
    await _dataSource.updateTodo(id, check);
  }

  // 투두리스트 지우기
  @override
  Future<void> deleteTodos(List<TodoModel> deleteTodoList) async {
    await _dataSource
        .deleteTodos(deleteTodoList.map((e) => e.toEntity()).toList());
  }

  //투두리스트 모두 삭제
  @override
  Future<void> deleteAllTodos() async {
    await _dataSource.deleteAllTodos();
  }

  //위젯 텍스트 색상 가져오기
  @override
  Future<String> getTodoTextColor() async {
    return _dataSource.getTodoTextColor();
  }

  //위젯 텍스트 색상 저장
  @override
  Future<String> setTodoTextColor() async {
    return _dataSource.setTodoTextColor();
  }
}
