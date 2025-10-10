import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';

abstract class CalendarRepository {
  //특정 날짜의 이벤트 가져오기
  Future<List<CalendarModel>> getEvents(String email, String date);

  //총 작성한 카운트 가져오기
  Future<int> getEventTotalCount(String email);

  //특정 날짜의 이벤트 저장
  Future<void> setEvent(String email, CalendarModel event);

  //모든 이벤트 가져오기
  Future<List<CalendarModel>> getEventsAll(String email, bool sort);
}
