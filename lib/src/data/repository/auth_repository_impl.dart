import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/auth_data_source.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/domain/model/user_model.dart';
import 'package:my_little_memory_diary/src/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  //로그인 함수
  @override
  Future<void> submit(String email, String password) async {
    try {
      return await _dataSource.submit(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw ErrorException('로그인에 실패했습니다.');
      }
    }
  }

  //토큰 업데이트
  @override
  Future<void> updateUserToken(String email, String token) async {
    await _dataSource.updateUserToken(email, token);
  }

  @override
  //비밀번호 찾기
  Future<bool> findPassword(String email) async {
    try {
      bool result = await _dataSource.findPassword(email);
      if (!result) {
        throw UserNotFoundException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailException();
      } else {
        throw ErrorException('비밀번호 재설정 이메일 전송에 실패했습니다.');
      }
    }
    return true;
  }

  //회원가입
  @override
  Future<void> signUp(String name, String email, String password) async {
    try {
      String token = await _dataSource.getUserToken();
      UserModel userModel = UserModel(
        userName: name,
        email: email,
        device: token,
        joinDate: Timestamp.now(),
      );
      await _dataSource.signUp(userModel.email!, password,
          userModel.userName ?? '', userModel.toJson());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else {
        throw ErrorException('회원가입에 실패했습니다.');
      }
    }
  }

  //구글 회원가입 후 로그인
  @override
  Future<void> signUpByGoogle() async {
    try {
      UserCredential userCredential = await _dataSource.signUpByGoogle();
      UserModel userModel = UserModel(
        userName: userCredential.user?.displayName ?? '',
        email: userCredential.user?.email ?? '',
        device: await _dataSource.getUserToken(),
        joinDate: Timestamp.now(),
      );
      await _dataSource.signInByGoogle(
          userModel.email ?? "", userModel.toJson());
    } catch (e) {
      throw ErrorException('구글 로그인에 실패했습니다.');
    }
  }
}
