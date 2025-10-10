import 'package:my_little_memory_diary/src/domain/model/calendar_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/calendar_repository.dart';

class SetCalendarUseCase {
  final CalendarRepository _repository;
  SetCalendarUseCase(this._repository);

  Future<void> setEvent(String email, CalendarModel event) async {
    await _repository.setEvent(email, event);
  }
}
