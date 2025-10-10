import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart'
    show userRepositoryProvider;
import 'package:my_little_memory_diary/src/domain/model/user_model.dart';
import 'package:my_little_memory_diary/src/domain/use_case/user/delete_user_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/user/feedback_user_use_case.dart';
import 'package:my_little_memory_diary/src/domain/use_case/user/verify_user_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/user_notifier.dart';

// 유스케이스
final deleteUserUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return DeleteUserUseCase(userRepository);
});
final verifyUserUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return VerifyUserUseCase(userRepository);
});
final feedbackUserUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return FeedbackUserUseCase(userRepository);
});

// 유저 프로바이더
final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, UserModel?>(() {
  return UserNotifier();
});
