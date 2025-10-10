// 유스케이스
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/provider/repository_providers.dart';
import 'package:my_little_memory_diary/src/domain/use_case/backup_drive/backup_drive_use_case.dart';
import 'package:my_little_memory_diary/src/presentation/features/notifiers/backup_notifier.dart';

final backupDrivdeUseCase = Provider((ref) {
  final repository = ref.watch(backupDriveRepositoryProvider);
  return BackupDriveUseCase(repository);
});

final backupNotifierProvider = AsyncNotifierProvider<BackupNotifier, void>(() {
  return BackupNotifier();
});
