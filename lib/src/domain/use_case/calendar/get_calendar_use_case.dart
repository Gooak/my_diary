import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/calendar_repository.dart';

class GetCalendarUseCase {
  final CalendarRepository _repository;
  GetCalendarUseCase(this._repository);

  Future<List<CalendarModel>> getEvents(String email, String date) {
    return _repository.getEvents(email, date);
  }

  Future<int> getEventTotalCount(String email) async {
    return await _repository.getEventTotalCount(email);
  }
}
