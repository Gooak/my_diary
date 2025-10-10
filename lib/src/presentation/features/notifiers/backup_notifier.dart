import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/backup_provider.dart';

class BackupNotifier extends AsyncNotifier<void> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  //구글 드라이브 백업
  Future<void> backUpDrive() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(backupDrivdeUseCase).backUpDrive();
    });
  }

  //구글 드라이브 파일 다운로드
  Future<void> downloadDrive() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(backupDrivdeUseCase).downloadDrive();
    });
  }
}
