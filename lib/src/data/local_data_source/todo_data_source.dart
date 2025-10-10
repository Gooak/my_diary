import 'package:hive/hive.dart';
import 'package:my_little_memory_diary/src/data/local/entity/todo_entity.dart';

abstract class TodoDataSource {
  //전체 투두 개수
  Future<List<TodoEntity>> getTodoList();

  //선택한 날짜 투두 리스트
  Future<List<TodoEntity>> getTodosByDate(String date);

  //투두 추가
  Future<void> addTodo(List<TodoEntity> todos);

  //투두 수정
  Future<void> updateTodo(int id, bool isChecked);

  //투두 삭제
  Future<void> deleteTodos(List<TodoEntity> todos);

  //전체 투두 삭제
  Future<void> deleteAllTodos();

  //투두 색상 가져오기
  Future<String> getTodoTextColor();

  //투두 색상 변경
  Future<String> setTodoTextColor();
}

class TodoDataSourceImpl implements TodoDataSource {
  //전체 투두 개수
  @override
  Future<List<TodoEntity>> getTodoList() async {
    var myTodo = Hive.box<TodoEntity>('myTodo').values.toList();
    return myTodo;
  }

  //선택한 날짜 투두 리스트
  @override
  Future<List<TodoEntity>> getTodosByDate(String selectedDayString) async {
    var myTodo = Hive.box<TodoEntity>('myTodo')
        .values
        .where((todo) => todo.date.contains(selectedDayString))
        .toList();
    return myTodo;
  }

  //투두 추가
  @override
  Future<void> addTodo(List<TodoEntity> addTodoList) async {
    final box = Hive.box<TodoEntity>('myTodo');
    int id = 0;
    if (box.isNotEmpty) {
      final item = box.getAt(box.length - 1);

      if (item != null) {
        id = item.id + 1;
      }
    }
    for (var todo in addTodoList) {
      todo = todo.copyWith(id: id);
      box.put(id, todo);
      id += 1;
    }
  }

  //투두 수정
  @override
  Future<void> updateTodo(int id, bool check) async {
    final box = Hive.box<TodoEntity>('myTodo');
    TodoEntity? todo = box.get(id);
    todo = todo!.copyWith(checkTodo: check);
    box.put(id, todo);
  }

  //투두 삭제
  @override
  Future<void> deleteTodos(List<TodoEntity> deleteTodoList) async {
    final box = Hive.box<TodoEntity>('myTodo');
    for (var todo in deleteTodoList) {
      box.delete(todo.id);
    }
  }

  //전체 투두 삭제
  @override
  Future<void> deleteAllTodos() async {
    var myTodo = Hive.box<TodoEntity>('myTodo').values.toList();
    final box = await Hive.openBox<TodoEntity>('myTodo');
    for (var todo in myTodo) {
      box.delete(todo.id);
    }
  }

  //투두 색상 가져오기
  @override
  Future<String> getTodoTextColor() async {
    var myTodo = Hive.box<String>('todoTextColor');
    String todoTextColor = myTodo.get('todoTextColor') ?? '1';
    return todoTextColor;
  }

  //투두 색상 변경
  @override
  Future<String> setTodoTextColor() async {
    var myTodo = Hive.box<String>('todoTextColor');
    String todoTextColor;
    if (myTodo.get('todoTextColor') == '0' ||
        myTodo.get('todoTextColor') == null) {
      myTodo.put('todoTextColor', '1');
      todoTextColor = '1';
    } else {
      myTodo.put('todoTextColor', '0');
      todoTextColor = '0';
    }
    return todoTextColor;
  }
}
