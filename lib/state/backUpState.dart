import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_little_memory_diary/components/loading.dart';
import 'package:my_little_memory_diary/serverRepository/googleBackUp_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class GoogleBackUpState {
  final googleBackUpRepository = GoogleBackUpRepository();

  late GoogleSignInAccount? googleUserToken;
  Future<void> signIn() async {
    googleUserToken = await googleBackUpRepository.signIn();
  }

  Future<String> backUp() async {
    try {
      if (googleUserToken == null) {
        return '구글 로그인 후 진행해 주세요';
      }
      showLoading();
      final hiveRoute = await getApplicationDocumentsDirectory();
      Directory hiveDir = Directory('${hiveRoute.path}/my_diary_files');
      // File zipFile = File('${hiveRoute.path}/my_diary_files.zip');

      // final zipFilePath = join(hiveRoute.path, 'my_diary_files.zip');

      // final encoder = ZipFileEncoder();
      // encoder.create(zipFilePath);

      // encoder.addDirectory(hiveDir);

      final driveApi = await googleBackUpRepository.getDriveApi(googleUserToken!);
      final driveFile = await googleBackUpRepository.getDriveFile(driveApi: driveApi!, filename: 'my_diary_files.zip');
      List<FileSystemEntity> files = hiveDir.listSync(recursive: true);
      for (FileSystemEntity file in files) {
        if (file is File) {
          await googleBackUpRepository.upLoad(driveApi: driveApi, file: file, driveFileId: driveFile?.id);
        }
      }
      // encoder.close();
      // await zipFile.delete();
    } catch (e) {
      dismissLoading();
      return '잘못된 접근입니다. 다시시도해주세요';
    }

    dismissLoading();
    return '백업에 성공하셨습니다.';
  }

  Future<String> restoreDB() async {
    try {
      Directory hiveRoute = await getApplicationDocumentsDirectory();
      final String path = join(hiveRoute.path, 'my_diary_files');

      if (googleUserToken == null) {
        return '구글 로그인 후 진행해 주세요';
      }
      showLoading();

      final driveApi = await googleBackUpRepository.getDriveApi(googleUserToken!);

      List item = ['mytodo.lock', 'mytodo.hive', 'apptheme.lock', 'apptheme.hive', 'tododaycount.lock', 'tododaycount.hive'];
      var itemfile = [];
      for (int i = 0; i < item.length; i++) {
        final file = await googleBackUpRepository.getDriveFile(driveApi: driveApi!, filename: item[i]);
        if (file == null) {
          return '복원할 파일이 없습니다.';
        } else {
          itemfile.add(file);
        }
      }

      for (int i = 0; i < item.length; i++) {
        String pathList = join(path, item[i]);
        File downLoadFile = await googleBackUpRepository.downLoad(driveApi: driveApi!, driveFileId: itemfile[i].id!, localPath: pathList);
        print(downLoadFile);
        print(downLoadFile.path);
        print(downLoadFile.absolute);
      }

      // final extractToDir = Directory('${hiveRoute.path}/my_diary_files');
      // extractToDir.createSync();

      // Directory hiveDir = Directory('${hiveRoute.path}/my_diary_files');
      // Directory zipFile = Directory('${hiveRoute.path}/my_diary_files.zip');

      // final bytes = downLoadFile.readAsBytesSync();
      // final archive = ZipDecoder().decodeBytes(bytes);
      // for (final files in archive) {
      //   final filename = join(extractToDir.path, files.name);
      //   if (files.isFile) {
      //     final data = files.content as List<int>;
      //     File(filename)
      //       ..createSync(recursive: true)
      //       ..writeAsBytesSync(data);
      //   } else {
      //     Directory(filename).create(recursive: true);
      //   }
      // }
    } catch (e) {
      dismissLoading();
      return '잘못된 접근입니다. 다시시도해주세요';
    }
    dismissLoading();
    return '복원에 성공하셨습니다. 앱을 다시시작하셔야 복원된 기록이 보여집니다.';
  }

  Future<String> paginate() async {
    try {
      if (googleUserToken == null) {
        return '구글 로그인 후 진행해 주세요';
      }
      final driveApi = await googleBackUpRepository.getDriveApi(googleUserToken!);
      final file = await googleBackUpRepository.getDriveFile(driveApi: driveApi!, filename: 'my_diary_files');

      String dateTime = "";
      DateFormat dateFormat = DateFormat('yy/MM/dd');

      if (file == null) {
        return '파일이 없음';
      } else {
        if (file.modifiedTime != null) {
          dateTime = dateFormat.format(file.modifiedTime!);
        } else if (file.createdTime != null) {
          dateTime = dateFormat.format(file.createdTime!);
        }
        return '$dateTime에 저장된 파일이 있음';
      }
    } catch (e) {
      return '에러!';
    }
  }
}
