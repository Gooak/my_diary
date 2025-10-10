import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/services/loading_service.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/auth_provider.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/presentation/features/login_page.dart/find_passwd.dart';
import 'package:my_little_memory_diary/src/presentation/features/login_page.dart/signup_page.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SigninPage extends ConsumerStatefulWidget {
  const SigninPage({super.key});

  @override
  ConsumerState<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends ConsumerState<SigninPage> {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPasswd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      authNotifierProvider,
      (previous, next) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        if (next is AsyncError) {
          if (next.error is ErrorException) {
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text((next.error as ErrorException).message)),
            );
          }
        }
      },
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: PopScope(
        canPop: false, //!EasyLoading.isShow,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) return;
        },
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExtendedImage.asset(
                'images/app_logo.png',
                width: size.width / 3,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: size.width - 50,
                child: TextField(
                  controller: textEmail,
                  decoration: DesignInputDecoration(
                          hintText: '이메일',
                          icon: const Icon(Icons.email),
                          circular: 5,
                          hintCount: '')
                      .inputDecoration,
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
                  decoration: DesignInputDecoration(
                          hintText: '비밀번호',
                          icon: const Icon(Icons.key),
                          circular: 5,
                          hintCount: '')
                      .inputDecoration,
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
                    LoadingOverlayService.runWithLoading(context, () async {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .login(textEmail.text.trim(), textPasswd.text.trim());
                    });
                  },
                  child: const Text("로그인"),
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
                    LoadingOverlayService.runWithLoading(context, () async {
                      await ref
                          .read(authNotifierProvider.notifier)
                          .googleSignUp();
                    });
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
