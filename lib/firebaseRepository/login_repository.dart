import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_diary/components/loading.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:my_diary/model/user_model.dart';

class LoginRepository {
  //로그인 함수
  static Future<void> submit(BuildContext context, String email, String passwd) async {
    showLoading();
    final singUp = FirebaseAuth.instance;
    FocusScope.of(context).unfocus();
    if (email == "" || passwd == "") {
      showCustomSnackBar(context, '이메일 주소, 비밀번호를 입력해주세요');
    } else {
      try {
        await singUp.signInWithEmailAndPassword(email: email, password: passwd);
        final userToken = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance.collection('UserInfo').doc(email).update({'device': userToken});
      } on FirebaseAuthException catch (e) {
        //로그인 예외처리
        if (e.code == 'user-not-found') {
          if (context.mounted) {
            showCustomSnackBar(context, '등록되지 않은 이메일입니다! 회원가입을 진행해주세요');
          }
        } else if (e.code == 'wrong-password') {
          if (context.mounted) {
            showCustomSnackBar(context, '비밀번호가 틀렸습니다!');
          }
        } else if (e.code == 'invalid-email') {
          if (context.mounted) {
            showCustomSnackBar(context, '잘못된 이메일 형식입니다!');
          }
        }
      }
    }
    dismissLoading();
  }

  //구글 로그인 함수
  static Future<UserCredential> signInWithGoogle() async {
    showLoading();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userToken = await FirebaseMessaging.instance.getToken();
    var data = await FirebaseFirestore.instance.collection('UserInfo').where('email', isEqualTo: googleUser?.email).get();

    if (data.size == 0) {
      //아이디 정보가 없으면 추가
      UserInformation user =
          UserInformation(userName: googleUser?.displayName, email: googleUser?.email, device: userToken.toString(), joinDate: Timestamp.now());
      await FirebaseFirestore.instance.collection('UserInfo').doc(user.email).set(user.toJson());
    } else {
      final userToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('UserInfo').doc(googleUser?.email).update({'device': userToken});
    }
    dismissLoading();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //비밀번호 찾기
  static Future<void> findPassword(BuildContext context, String email) async {
    final find = await FirebaseFirestore.instance.collection('UserInfo').where('email', isEqualTo: email).get();
    if (find.docs.isNotEmpty) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        showCustomSnackBar(context, '입력한 이메일에 발송하였습니다!');
      }
    } else {
      if (context.mounted) {
        showCustomSnackBar(context, '해당 이메일이 존재하지 않습니다.');
      }
    }
  }

  //일반 회원가입
  static Future<void> signUp(String? name, String? email, String? passwd) async {
    showLoading();

    final userToken = await FirebaseMessaging.instance.getToken();

    UserInformation user = UserInformation(userName: name, email: email, device: userToken.toString(), joinDate: Timestamp.now());
    await FirebaseFirestore.instance.collection('UserInfo').doc(user.email).set(user.toJson());
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: passwd!);
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    dismissLoading();
  }
}