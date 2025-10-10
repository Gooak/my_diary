import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';

class FindPasswordAuthUseCase {
  final AuthRepository _repository;
  FindPasswordAuthUseCase(this._repository);

  Future<bool> findPassword(String email) async {
    return await _repository.findPassword(email);
  }
}