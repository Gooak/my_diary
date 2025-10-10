import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/calendar_data_source.dart';
import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource _dataSource;
  CalendarRepositoryImpl(this._dataSource);

  //특정 날짜의 이벤트 가져오기
  @override
  Future<List<CalendarModel>> getEvents(String email, String date) async {
    QuerySnapshot result = await _dataSource.getEvents(email, date);
    List<CalendarModel> calendarList = [];
    for (var element in result.docs) {
      calendarList.add(CalendarModel.fromDocumentSnapshot(element));
    }
    return calendarList;
  }

  //총 작성한 카운트 가져오기
  @override
  Future<int> getEventTotalCount(String email) {
    return _dataSource.getEventTotalCount(email);
  }

  //특정 날짜의 이벤트 저장
  @override
  Future<void> setEvent(String email, CalendarModel event) async {
    await _dataSource.setEvent(email, event.date, event.toJson());
  }

  //모든 이벤트 가져오기
  @override
  Future<List<CalendarModel>> getEventsAll(String email, bool sort) async {
    QuerySnapshot result = await _dataSource.getEventsAll(email, sort);
    List<CalendarModel> calendarList = [];
    for (var element in result.docs) {
      calendarList.add(CalendarModel.fromDocumentSnapshot(element));
    }
    return calendarList;
  }
}
