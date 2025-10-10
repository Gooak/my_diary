import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/calendar_provider.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class CalendarNotifier extends AsyncNotifier<List<CalendarModel>> {
  CalendarModel? _eventViewItem;
  CalendarModel? get eventViewItem => _eventViewItem;

  final DateFormat formmated = DateFormat('yyyy-MM-dd');
  final DateFormat formattedByYearMonth = DateFormat('yyyy-MM');

  int calendarTotalCount = 0;

  @override
  Future<List<CalendarModel>> build() async {
    DateTime date = DateTime.now();
    final userEmail = ref.watch(userNotifierProvider).value!.email ?? '';
    calendarTotalCount =
        await ref.read(getCalendarUseCase).getEventTotalCount(userEmail);
    return await getEvents(date);
  }

  // 달력 이벤트 가져오기
  Future<void> getEventByDate(DateTime selectedDay) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await getEvents(selectedDay);
    });
  }

  // 달력 페이지 넘길때 조회
  Future<void> getEnvetsForPageChanged(DateTime date) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await getEvents(date);
    });
  }

  // 달력 이벤트 조회
  Future<List<CalendarModel>> getEvents(DateTime date) async {
    final userEmail = ref.watch(userNotifierProvider).value!.email ?? '';
    var item = await ref
        .read(getCalendarUseCase)
        .getEvents(userEmail, formattedByYearMonth.format(date));
    return item;
  }

  // 해당 날짜 캘린더 이벤트
  CalendarModel? getEventsForDay(DateTime day) {
    if (state.value != null && state.value!.isNotEmpty) {
      String dayToString = formmated.format(day);
      return state.value!.firstWhereOrNull((e) => e.date == dayToString);
    } else {
      return null;
    }
  }

  // 해당 날짜 이벤트 View 함수
  Future<void> getEventViewForDay(DateTime day) async {
    _eventViewItem = getEventsForDay(day);
  }

  // 해당 날짜 이벤트 저장
  Future<void> setEvent(
      String email, CalendarModel event, bool isNewEvent) async {
    await ref.read(setCalendarUseCase).setEvent(email, event);
    if (isNewEvent == true) {
      calendarTotalCount++;
    }
  }
}
