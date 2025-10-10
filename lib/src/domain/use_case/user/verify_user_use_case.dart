import 'package:my_little_memory_diary/src/domain/model/user_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/user_repository.dart';

class VerifyUserUseCase {
  final UserRepository _repository;
  VerifyUserUseCase(this._repository);

  Future<UserModel?> verifyUser(String email) async {
    return await _repository.verifyUser(email);
  }
}
