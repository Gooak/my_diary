import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_little_memory_diary/src/core/constants.dart';

abstract class AuthDataSource {
  //로그인
  Future<void> submit(String email, String password);

  //토큰 업데이트
  Future<void> updateUserToken(String email, String token);

  //비밀번호 찾기
  Future<bool> findPassword(String email);

  //회원가입
  Future<void> signUp(
      String email, String password, String name, Map<String, dynamic> user);

  //토큰 가져오기
  Future<String> getUserToken();

  //구글 회원가입
  Future<UserCredential> signUpByGoogle();

  //구글 로그인
  Future<void> signInByGoogle(String email, Map<String, dynamic> userInfo);
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //로그인 함수
  @override
  Future<User> submit(String email, String password) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user!;
  }

  //토큰 업데이트
  @override
  Future<void> updateUserToken(String email, String token) async {
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .update({'device': token});
  }

  //비밀번호 찾기
  @override
  Future<bool> findPassword(String email) async {
    final find = await FirebaseFirestore.instance
        .collection('UserInfo')
        .where('email', isEqualTo: email)
        .get();
    if (find.docs.isNotEmpty) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } else {
      return false;
    }
  }

  //회원가입
  @override
  Future<void> signUp(String email, String password, String name,
      Map<String, dynamic> user) async {
    var joinUser = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(email)
        .set(user);
    joinUser.user!.sendEmailVerification();
  }

  //구글 회원가입
  @override
  Future<UserCredential> signUpByGoogle() async {
    _googleSignIn.initialize(
        serverClientId: googleServerClientId, clientId: googleClientId);

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  //구글 로그인
  @override
  Future<void> signInByGoogle(
      String email, Map<String, dynamic> userInfo) async {
    var data = await FirebaseFirestore.instance
        .collection('UserInfo')
        .where('email', isEqualTo: email)
        .get();
    if (data.size == 0) {
      await FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(email)
          .set(userInfo);
    } else {
      final userToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(email)
          .update({'device': userToken});
    }
  }

  //토큰 가져오기
  @override
  Future<String> getUserToken() async {
    return await FirebaseMessaging.instance.getToken() ?? '';
  }
}
