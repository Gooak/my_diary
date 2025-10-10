import 'package:my_little_memory_diary/src/domain/repository/backup_drive_repository.dart';

class BackupDriveUseCase {
  final BackupDriveRepository _repository;
  BackupDriveUseCase(this._repository);

  Future<void> backUpDrive() async {
    await _repository.backUpDrive();
  }

  Future<void> downloadDrive() async {
    await _repository.downloadDrive();
  }
}
