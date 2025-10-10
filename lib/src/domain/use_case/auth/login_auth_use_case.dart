import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';

class LoginAuthUserCase {
  final AuthRepository _repository;
  LoginAuthUserCase(this._repository);

  Future<void> login(String email, String password) async {
    await _repository.submit(email, password);
  }
}