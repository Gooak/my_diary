import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_diary/repository/login_repository.dart';
import 'package:my_diary/view/login_page.dart/find_passwd.dart';
import 'package:my_diary/view/login_page.dart/signup_page.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPasswd = TextEditingController();
  String errorMessage = '';

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
                    LoginRepository.submit(context, textEmail.text.trim(), textPasswd.text.trim());
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FindPasswd(),
                          ));
                    },
                    child: const Text(
                      '비밀번호찾기',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ));
                    },
                    child: const Text(
                      '회원가입',
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SignInButton(
                  Buttons.google,
                  onPressed: () async {
                    await LoginRepository.signInWithGoogle();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
