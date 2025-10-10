import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/find_password_auth_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/sign_up_auth_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/auth_provider.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/login_auth_use_case.dart';

class AuthNotifier extends AsyncNotifier<void> {
  late final LoginAuthUserCase _loginAuthUserCase;
  late final FindPasswordAuthUseCase _findPasswordAuthUseCase;
  late final SignUpAuthUseCase _signUpAuthUseCase;

  @override
  Future<void> build() async {
    _loginAuthUserCase = ref.read(loginAuthUserCaseProvider);
    _findPasswordAuthUseCase = ref.read(findPasswordAuthUseCase);
    _signUpAuthUseCase = ref.read(signUpAuthUseCaseProvider);
  }

  // 로그인 메서드
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _loginAuthUserCase.login(email, password);
    });
  }

  // 구글 로그인 메서드
  Future<void> googleSignUp() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(googleSignUpAuthUseCaseProvider).signUpByGoogle();
    });
  }

  // 비밀번호 찾기 메서드
  Future<bool> findPassword(String email) async {
    try {
      return await _findPasswordAuthUseCase.findPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  // 회원가입 메서드
  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _signUpAuthUseCase.signUp(name, email, password);
    });
  }
}
