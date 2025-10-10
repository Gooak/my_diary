import 'dart:io';

import 'package:collection/collection.dart';
import 'package:extended_image/extended_image.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:my_little_memory_diary/src/core/constants.dart';
import 'package:path/path.dart' as path;

class AuthenticatedClient extends http.BaseClient {
  final String accessToken;
  final http.Client _inner = http.Client();

  AuthenticatedClient(this.accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    return _inner.send(request);
  }
}

abstract class BackupDriveDataSource {
  //드라이브 권한 로그인
  Future<GoogleSignInClientAuthorization?> driveSignIn();

  //구글 로그아웃
  Future<void> signOut();

  //구글 드라이브 가져오기
  Future<drive.DriveApi> getDriveApi(GoogleSignInClientAuthorization auth);

  //구글 드라이브 파일 가져오기
  Future<drive.File?> getDriveFile(drive.DriveApi driveApi, String fileName);

  //구글 드라이브 파일 업로드
  Future<drive.File?> upLoad(
      drive.DriveApi driveApi, File file, String? driveFileId);

  //구글 드라이브 파일 다운로드
  Future<File> download(
      drive.DriveApi driveApi, drive.File driveFile, String localPath);
}

class BackupDriveDataSourceImpl implements BackupDriveDataSource {
  @override
  Future<GoogleSignInClientAuthorization?> driveSignIn() async {
    await GoogleSignIn.instance.initialize(
        serverClientId: googleServerClientId, clientId: googleClientId);

    final account = await GoogleSignIn.instance.authenticate();

    return await account.authorizationClient.authorizeScopes([
      drive.DriveApi.driveAppdataScope,
    ]);
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
  }

  @override
  Future<drive.DriveApi> getDriveApi(
      GoogleSignInClientAuthorization auth) async {
    final client = AuthenticatedClient(auth.accessToken);
    return drive.DriveApi(client);
  }

  @override
  Future<drive.File?> getDriveFile(
      drive.DriveApi driveApi, String fileName) async {
    drive.FileList fileList = await driveApi.files
        .list(spaces: googleDriveFolder, $fields: googleDriveFields);
    List<drive.File>? files = fileList.files;
    if (files == null) {
      return null;
    } else {
      return files.firstWhereOrNull((element) => element.name == fileName);
    }
  }

  @override
  Future<drive.File?> upLoad(
      drive.DriveApi driveApi, File file, String? driveFileId) async {
    drive.File driveFile = drive.File();
    driveFile.name = path.basename(file.absolute.path);

    late final drive.File response;
    if (driveFileId != null) {
      response = await driveApi.files.update(driveFile, driveFileId,
          uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
    } else {
      driveFile.parents = ["appDataFolder"];
      response = await driveApi.files.create(driveFile,
          uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
    }
    return response;
  }

  @override
  Future<File> download(
      drive.DriveApi driveApi, drive.File driveFile, String localPath) async {
    drive.Media media = await driveApi.files.get(driveFile.id!,
        downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    List<int> data = [];

    await media.stream.forEach((element) {
      data.addAll(element);
    });

    File file = File(localPath);
    file.writeAsBytesSync(data, flush: true);

    return file;
  }
}
