import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/services/loading_service.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/auth_provider.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPasswd = TextEditingController();
  TextEditingController textPasswd2 = TextEditingController();
  TextEditingController textName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    textEmail.dispose();
    textPasswd.dispose();
    textPasswd2.dispose();
    textName.dispose();
  }

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
        } else {
          scaffoldMessenger.showSnackBar(SnackBar(
            content: Text(('이메일 인증 후 로그인이 가능합니다.')),
          ));
        }
      },
    );

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppbar(),
      body: Form(
        key: _formKey,
        child: ListView(children: [
          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width - 50,
                  height: 80,
                  child: TextFormField(
                      controller: textEmail,
                      decoration: DesignInputDecoration(
                              hintText: '이메일',
                              icon: const Icon(Icons.email),
                              circular: 5,
                              hintCount: '')
                          .inputDecoration,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '이메일을 입력해주세요';
                        } else if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return '이메일 형식이 맞지 않습니다';
                        }
                        return null;
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width - 50,
                  height: 80,
                  child: TextFormField(
                    obscureText: true,
                    controller: textPasswd,
                    decoration: DesignInputDecoration(
                            hintText: '비밀번호 (숫자, 문자, 특수문자, 최소8자)',
                            icon: const Icon(Icons.key),
                            circular: 5,
                            hintCount: '')
                        .inputDecoration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      } else if (!RegExp(
                              r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$")
                          .hasMatch(value)) {
                        return '비밀번호 형식이 맞지않습니다!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width - 50,
                  height: 80,
                  child: TextFormField(
                    obscureText: true,
                    controller: textPasswd2,
                    decoration: DesignInputDecoration(
                            hintText: '비밀번호 확인',
                            icon: const Icon(Icons.key),
                            circular: 5,
                            hintCount: '')
                        .inputDecoration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '비밀번호를 입력해주세요';
                      } else if (value != textPasswd.text) {
                        return '비밀번호가 다릅니다!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width - 50,
                  height: 80,
                  child: TextFormField(
                    controller: textName,
                    decoration: DesignInputDecoration(
                            hintText: '이름 or 닉네임',
                            icon: const Icon(Icons.person),
                            circular: 5,
                            hintCount: '')
                        .inputDecoration,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '이름 or 닉네임을 입력해주세요!';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: size.width - 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      LoadingOverlayService.runWithLoading(context, () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          await ref.read(authNotifierProvider.notifier).signUp(
                                textName.text.trim(),
                                textEmail.text.trim(),
                                textPasswd.text.trim(),
                              );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      });
                    },
                    child: isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(3),
                            child: const CircularProgressIndicator(),
                          )
                        : const Text("로그인"),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        '회원가입',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
