import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';

class SignUpAuthUseCase {
  final AuthRepository _repository;
  SignUpAuthUseCase(this._repository);

  final List<String> _emailCheckList = const ['naver.com', 'gmail.com', 'daum.net', 'kakao.com', 'nate.com', 'hanmail.net'];

  Future<void> signUp(String name, String email, String password) async {
    final domain = email.split('@').last;
    if (!_emailCheckList.contains(domain)) {
      throw InvalidEmailDomainException();
    }

    await _repository.signUp(name, email, password);
  }
}