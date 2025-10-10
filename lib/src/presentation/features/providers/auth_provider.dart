
//로그인 프로바이더
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart' show authRepositoryProvider;
import 'package:my_little_memory_diary/src/domain/use_case/auth/find_password_auth_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/google_sign_up_auth_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/login_auth_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/auth/sign_up_auth_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/auth_notifier.dart';

//auth 로그인 유스케이스
final loginAuthUserCaseProvider = Provider<LoginAuthUserCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginAuthUserCase(repository);
});
final googleSignUpAuthUseCaseProvider = Provider<GoogleSignUpAuthUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GoogleSignUpAuthUseCase(repository);
});
final findPasswordAuthUseCase = Provider<FindPasswordAuthUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return FindPasswordAuthUseCase(repository);
});
final signUpAuthUseCaseProvider = Provider<SignUpAuthUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpAuthUseCase(repository);
});

//auth 프로바이더
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});
