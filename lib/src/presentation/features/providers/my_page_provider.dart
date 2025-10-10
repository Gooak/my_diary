import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/domain/model/my_page_data_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/calendar_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/diary_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/todo_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

//마이페이지 프로바이더
final myPageDataProvider = Provider<AsyncValue<MyPageDataModel>>((ref) {
  final userAsync = ref.watch(userNotifierProvider);
  final diaryAsync = ref.watch(diaryNotifierProvider);
  final calendarAsync = ref.watch(calendarNotifierProvider);
  final todoAsync = ref.watch(todoNotifierProvider);

  if (userAsync is AsyncLoading ||
      diaryAsync is AsyncLoading ||
      calendarAsync is AsyncLoading ||
      todoAsync is AsyncLoading) {
    return const AsyncLoading();
  }

  if (diaryAsync.hasError || calendarAsync.hasError || todoAsync.hasError) {
    return AsyncError('데이터 로딩 중 에러 발생', StackTrace.current);
  }

  final user = userAsync.value;
  final diaryList = diaryAsync.value;
  final calendarList = calendarAsync.value;

  if (user == null ||
      user.joinDate == null ||
      diaryList == null ||
      calendarList == null) {
    return AsyncError('필수 데이터가 없습니다.', StackTrace.current);
  }

  final day = DateTime.now()
      .difference(user.joinDate!.toDate().subtract(const Duration(days: 1)))
      .inDays;

  final calendar = ref.read(calendarNotifierProvider.notifier);
  final todo = ref.read(todoNotifierProvider.notifier);

  final myPageData = MyPageDataModel(
    day,
    diaryAsync.value?.length ?? 0,
    calendar.calendarTotalCount,
    todo.todoCount,
    todo.activeTodoCount,
  );

  // 5. 최종적으로 계산된 데이터를 AsyncData로 감싸서 반환합니다.
  return AsyncData(myPageData);
});
