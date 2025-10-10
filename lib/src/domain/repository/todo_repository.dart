import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';

abstract class TodoRepository {
  //모든 투두리스트 들고오기
  Future<List<TodoModel>> getTodoList();

  //선택한 날짜의 투두리스트 들고오기
  Future<List<TodoModel>> getTodosByDate(String selectedDayString);

  //투두리스트 추가
  Future<void> addTodo(List<TodoModel> addTodoList);

  //투두리스트 수정
  Future<void> updateTodo(int id, bool check);

  //투두리스트 삭제
  Future<void> deleteTodos(List<TodoModel> deleteTodoList);

  //모든 투두리스트 삭제
  Future<void> deleteAllTodos();

  //배경 위젯 색상 들고오기
  Future<String> getTodoTextColor();

  //배경 위젯 색상 설정
  Future<String> setTodoTextColor();
}
