import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class GoogleBackUpRepository {
  Future<GoogleSignInAccount?> signIn() async {
    var googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveAppdataScope]);

    return await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
  }

  Future<drive.DriveApi?> getDriveApi(GoogleSignInAccount googleSignInAccount) async {
    final header = await googleSignInAccount.authHeaders;
    GoogleAuthClient googleAuthClient = GoogleAuthClient(header: header);
    return drive.DriveApi(googleAuthClient);
  }

  Future<drive.File?> upLoad({required drive.DriveApi driveApi, required File file, String? driveFileId}) async {
    drive.File driveFile = drive.File();
    driveFile.name = path.basename(file.absolute.path);

    late final response;
    if (driveFileId != null) {
      response = await driveApi.files.update(driveFile, driveFileId, uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
    } else {
      driveFile.parents = ["appDataFolder"];
      response = await driveApi.files.create(driveFile, uploadMedia: drive.Media(file.openRead(), file.lengthSync()));
    }
    return response;
  }

  Future<File> downLoad({required String driveFileId, required drive.DriveApi driveApi, required String localPath}) async {
    drive.Media media = await driveApi.files.get(driveFileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

    List<int> data = [];

    await media.stream.forEach((element) {
      data.addAll(element);
    });

    File file = File(localPath);
    file.writeAsBytesSync(data, flush: true);

    return file;
  }

  Future<drive.File?> getDriveFile({required drive.DriveApi driveApi, required filename}) async {
    drive.FileList fileList = await driveApi.files.list(spaces: "appDataFolder", $fields: "files(id,name,modifiedTime)");
    List<drive.File>? files = fileList.files;

    //Bad state: No element 발생함
    try {
      drive.File? driveFile = files?.firstWhere((element) => element.name == filename);
      return driveFile;
    } catch (e) {
      return null;
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> header;
  final http.Client client = http.Client();

  GoogleAuthClient({required this.header});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(header);
    return client.send(request);
  }
}
