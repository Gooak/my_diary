import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_little_memory_diary/src/core/constants.dart';
import 'package:my_little_memory_diary/src/data/remote_data_source/backup_drive_data_source.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/domain/repository/backup_drive_repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BackupDriveRepositoryImpl implements BackupDriveRepository {
  final BackupDriveDataSource _dataSource;
  BackupDriveRepositoryImpl(this._dataSource);

  @override
  Future<void> backUpDrive() async {
    try {
      GoogleSignInClientAuthorization? auth = await _dataSource.driveSignIn();
      if (auth == null) {
        throw ErrorException('로그인을 성공하지 못했습니다.');
      } else {
        final hiveRoute = await getApplicationDocumentsDirectory();
        Directory hiveDir = Directory('${hiveRoute.path}/$dirPath');
        final driveApi = await _dataSource.getDriveApi(auth);
        final driveFile =
            await _dataSource.getDriveFile(driveApi, backupFileName);

        List<FileSystemEntity> files = hiveDir.listSync(recursive: true);
        for (FileSystemEntity file in files) {
          if (file is File) {
            await _dataSource.upLoad(driveApi, file, driveFile?.id);
          }
        }
      }
    } catch (e) {
      throw ErrorException('데이터 백업에 실패하였습니다.');
    }
  }

  @override
  Future<void> downloadDrive() async {
    try {
      GoogleSignInClientAuthorization? auth = await _dataSource.driveSignIn();
      if (auth == null) {
        throw ErrorException('로그인을 성공하지 못했습니다.');
      } else {
        Directory hiveRoute = await getApplicationDocumentsDirectory();
        final String path = join(hiveRoute.path, 'my_diary_files');
        final driveApi = await _dataSource.getDriveApi(auth);

        var fileItems = [];
        for (var fileName in hiveFileNames) {
          final file = await _dataSource.getDriveFile(driveApi, fileName);
          if (file == null) {
            throw ErrorException('복원할 파일이 없습니다.');
          } else {
            fileItems.add(file);
          }
        }
        for (var fileItem in fileItems) {
          String filePath = join(path, fileItem.name);
          await _dataSource.download(driveApi, fileItem, filePath);
        }
      }
    } catch (e) {
      throw ErrorException('데이터 불러오기에 실패하였습니다.');
    }
  }
}
