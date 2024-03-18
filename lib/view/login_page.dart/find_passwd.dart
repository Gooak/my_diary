import 'package:flutter/material.dart';
import 'package:my_little_memory_diary/components/design.dart';
import 'package:my_little_memory_diary/serverRepository/login_repository.dart';

class FindPasswd extends StatefulWidget {
  const FindPasswd({super.key});

  @override
  State<FindPasswd> createState() => _FindPasswdState();
}

class _FindPasswdState extends State<FindPasswd> {
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
                    decoration:
                        DesignInputDecoration(hintText: '이메일 (가입된 이메일)', icon: const Icon(Icons.email), circular: 5, hintCount: '').inputDecoration,
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
                    if (_formKey.currentState!.validate()) {
                      await LoginRepository.findPassword(context, textEmail.text.trim());
                    }
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
