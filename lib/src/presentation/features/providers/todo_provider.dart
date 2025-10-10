import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart';
import 'package:my_little_memory_diary/src/domain/model/todo_model.dart';
import 'package:my_little_memory_diary/src/domain/use_case/todo/add_todo_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/todo/delete_todo_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/todo/get_todo_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/todo/update_todo_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/todo_notifier.dart';

//todo 유스케이스
final getTodoUseCaseProvider = Provider<GetTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodoUseCase(repository);
});
final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodoUseCase(repository);
});
final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodoUseCase(repository);
});
final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodoUseCase(repository);
});

//todo 프로바이더
final todoNotifierProvider =
    AsyncNotifierProvider<TodoNotifier, List<TodoModel>>(() {
  return TodoNotifier();
});
