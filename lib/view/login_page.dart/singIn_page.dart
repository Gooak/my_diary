import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_diary/components/snackBar.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _singUp = FirebaseAuth.instance;

  TextEditingController textEmail = TextEditingController();
  TextEditingController textPasswd = TextEditingController();
  String errorMessage = '';

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: PopScope(
        canPop: !EasyLoading.isShow,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
        },
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width - 50,
                child: TextField(
                  controller: textEmail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      hintText: '이메일'),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width - 50,
                child: TextField(
                  obscureText: true,
                  controller: textPasswd,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      hintText: '비밀번호'),
                  keyboardType: TextInputType.visiblePassword,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: size.width - 50,
                child: ElevatedButton(
                  onPressed: () async {
                    _submit(context);
                  },
                  child: const Text(
                    "로그인",
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const FindPasswd(),
                      //     ));
                    },
                    child: const Text(
                      '비밀번호찾기',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const FindPasswd(),
                      //     ));
                    },
                    child: const Text(
                      '회원가입',
                    ),
                  ),
                ],
              ),
              SignInButton(
                Buttons.google,
                onPressed: () async {
                  await signInWithGoogle();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (textEmail.text.trim() == "" || textPasswd.text.trim() == "") {
      showCustomSnackBar(context, '이메일 주소, 비밀번호를 입력해주세요');
      return;
    }
    try {
      await _singUp.signInWithEmailAndPassword(email: textEmail.text.trim(), password: textPasswd.text.trim());
      final userToken = await FirebaseMessaging.instance.getToken();
      await FirebaseFirestore.instance.collection('UserInfo').doc(textEmail.text.trim()).update({'device': userToken});
    } on FirebaseAuthException catch (e) {
      //로그인 예외처리
      if (e.code == 'user-not-found') {
        print(e.code);
        if (context.mounted) {
          showCustomSnackBar(context, '등록되지 않은 이메일입니다! 회원가입을 진행해주세요');
        }
      } else if (e.code == 'wrong-password') {
        print(e.code);
        if (context.mounted) {
          showCustomSnackBar(context, '비밀번호가 틀렸습니다!');
        }
      } else {
        print(e.code);
      }
    }
  }
}
