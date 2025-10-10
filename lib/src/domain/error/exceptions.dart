// 모든 인증 에러의 부모 클래스
class ErrorException implements Exception {
  final String message;
  ErrorException(this.message);
}

class UserNotFoundException extends ErrorException {
  UserNotFoundException() : super('등록되지 않은 이메일입니다!');
}

class WrongPasswordException extends ErrorException {
  WrongPasswordException() : super('비밀번호가 틀렸습니다!');
}

class InvalidEmailException extends ErrorException {
  InvalidEmailException() : super('잘못된 이메일 형식입니다!');
}

class EmailNotVerifiedException extends ErrorException {
  EmailNotVerifiedException() : super('이메일을 인증해주세요.');
}

class EmailAlreadyInUseException extends ErrorException {
  EmailAlreadyInUseException() : super('이미 존재하는 계정입니다.');
}

class InvalidEmailDomainException extends ErrorException {
  InvalidEmailDomainException() : super('유효한 이메일이 아닙니다.');
}
