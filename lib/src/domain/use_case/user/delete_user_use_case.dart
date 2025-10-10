import 'package:my_little_memory_diary/src/domain/repository/user_repository.dart';

class DeleteUserUseCase {
  final UserRepository _repository;
  DeleteUserUseCase(this._repository);

  Future<void> deleteAccountReason(
      String email, String name, String text) async {
    await _repository.deleteAccountReason(email, name, text);
  }

  Future<void> deleteUser(String email) async {
    await _repository.deleteUser(email);
  }
}
