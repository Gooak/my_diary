import 'package:my_little_memory_diary/src/data/remote_data_source/user_data_source.dart';
import 'package:my_little_memory_diary/src/domain/model/user_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/user_repository.dart';

//로그인시 유저 정보가져오는 Repository
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _dataSource;
  UserRepositoryImpl(this._dataSource);

  //로그인
  @override
  Future<UserModel?> verifyUser(String email) async {
    var data = await _dataSource.verifyUser(email);
    if (data.docs.isEmpty) {
      return null;
    } else {
      return UserModel.fromJson(data.docs.first.data());
    }
  }

  //피드백
  @override
  Future<void> setFeedback(String email, String name, String feedback) async {
    await _dataSource.setFeedback(email, name, feedback);
  }

  //탈퇴사유
  @override
  Future<void> deleteAccountReason(
      String email, String name, String text) async {
    _dataSource.deleteAccountReason(email, name, text);
  }

  //회원탈퇴
  @override
  Future<void> deleteUser(String email) async {
    await _dataSource.deleteUser(email);
  }
}
