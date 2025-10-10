import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

abstract class ImageStorageDataSource {
  // 이미지 업로드
  Future<List<String>> uploadImage(String email, File image);

  // 이미지 삭제
  Future<void> deleteImage(String email, String imageUrl);
}

class ImageStorageDataSourceImpl implements ImageStorageDataSource {
  // 이미지 업로드
  @override
  Future<List<String>> uploadImage(String email, File image) async {
    String extension = '${DateTime.now()}${path.extension(image.path)}';
    final putImage =
        FirebaseStorage.instance.ref().child(email).child(extension);
    await putImage.putFile(image, SettableMetadata(contentType: 'image/jpg'));
    return [extension, await putImage.getDownloadURL()];
  }

  // 이미지 삭제
  @override
  Future<void> deleteImage(String email, String imageUrl) async {
    await FirebaseStorage.instance.ref().child(email).child(imageUrl).delete();
  }
}
