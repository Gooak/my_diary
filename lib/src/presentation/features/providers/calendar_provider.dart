import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/domain/use_case/calendar/get_calendar_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/calendar/set_calendar_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/calendar_notifier.dart';

// 유스 케이스
final getCalendarUseCase = Provider<GetCalendarUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return GetCalendarUseCase(repository);
});
final setCalendarUseCase = Provider<SetCalendarUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return SetCalendarUseCase(repository);
});

// 달력 일기 프로바이더
final calendarNotifierProvider =
    AsyncNotifierProvider<CalendarNotifier, List<CalendarModel>>(() {
  return CalendarNotifier();
});
