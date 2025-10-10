import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/services/loading_service.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/auth_provider.dart';

class FindPasswd extends ConsumerStatefulWidget {
  const FindPasswd({super.key});

  @override
  ConsumerState<FindPasswd> createState() => _FindPasswdState();
}

class _FindPasswdState extends ConsumerState<FindPasswd> {
  TextEditingController textEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: SizedBox(
                width: size.width - 50,
                height: 80,
                child: TextFormField(
                    controller: textEmail,
                    decoration: DesignInputDecoration(
                            hintText: '이메일 (가입된 이메일)',
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
            ),
            SizedBox(
              width: size.width - 50,
              child: ElevatedButton(
                  onPressed: () async {
                    LoadingOverlayService.runWithLoading(context, () async {
                      if (_formKey.currentState!.validate()) {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final navigator = Navigator.of(context);

                        final bool result = await ref
                            .read(authNotifierProvider.notifier)
                            .findPassword(textEmail.text);

                        if (!mounted) return;

                        if (result == true) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                                content: Text('이메일로 비밀번호 재설정 링크를 보냈습니다.')),
                          );
                          navigator.pop();
                        } else {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                                content: Text('이메일 전송에 실패했습니다. 다시 시도해주세요.')),
                          );
                        }
                      }
                    });
                  },
                  child: const Text('비밀번호 찾기')),
            ),
          ],
        ),
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
        '비밀번호 찾기',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
