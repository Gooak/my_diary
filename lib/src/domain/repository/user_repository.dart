import 'package:my_little_memory_diary/src/domain/model/user_model.dart';

abstract class UserRepository {
  //로그인
  Future<UserModel?> verifyUser(String email);

  //피드백
  Future<void> setFeedback(String email, String name, String feedback);

  //탈퇴사유
  Future<void> deleteAccountReason(String email, String name, String text);

  //회원탈퇴
  Future<void> deleteUser(String email);
}
