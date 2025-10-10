abstract class AuthRepository {
  //로그인
  Future<void> submit(String email, String password);

  //토큰 업데이트
  Future<void> updateUserToken(String email, String token);

  //비밀번호 찾기
  Future<bool> findPassword(String email);

  //회원가입
  Future<void> signUp(String name, String email, String password);

  //구글 회원가입
  Future<void> signUpByGoogle();
}
