abstract class BackupDriveRepository {
  //드라이브 백업
  Future<void> backUpDrive();

  //드라이브 복원
  Future<void> downloadDrive();
}
