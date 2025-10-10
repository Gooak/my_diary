import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';

class GoogleSignUpAuthUseCase {
  final AuthRepository _repository;
  GoogleSignUpAuthUseCase(this._repository);

  Future<void> signUpByGoogle() async {
    await _repository.signUpByGoogle();
  }
}