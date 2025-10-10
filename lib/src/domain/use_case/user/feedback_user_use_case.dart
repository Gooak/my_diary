import 'package:my_little_memory_diary/src/domain/repository/user_repository.dart';

class FeedbackUserUseCase {
  final UserRepository _repository;
  FeedbackUserUseCase(this._repository);

  Future<void> setFeedback(String email, String name, String feedback) async {
    return await _repository.setFeedback(email, name, feedback);
  }
}
