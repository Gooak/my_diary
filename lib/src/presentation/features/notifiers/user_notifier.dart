import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';
import 'package:my_little_memory_diary/src/domain/model/user_model.dart';

class UserNotifier extends AsyncNotifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  //로그인
  Future<void> loginUser(String email) async {
    if (email != "") {
      state = const AsyncLoading();

      // 에러 자동 처리 (AsyncValue.guard)
      state = await AsyncValue.guard(() async {
        final user =
            await ref.read(verifyUserUseCaseProvider).verifyUser(email);
        return user;
      });
    }
  }

  //로그아웃
  Future<void> logOut() async {
    state = const AsyncData(null);
  }

  //회원탈퇴
  Future<void> deleteUser(String email, String name, String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(deleteUserUseCaseProvider)
          .deleteAccountReason(email, name, text);
      await ref.read(deleteUserUseCaseProvider).deleteUser(email);
      return null;
    });
  }

  //피드백
  Future<void> setFeedback(String email, String name, String feedback) async {
    await ref
        .read(feedbackUserUseCaseProvider)
        .setFeedback(email, name, feedback);
  }
}
