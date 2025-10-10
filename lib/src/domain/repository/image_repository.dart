import 'dart:io';

abstract class ImageRepository {
  // 이미지 업로드
  Future<List<String>> uploadImage(String email, File image);

  // 이미지 삭제
  Future<void> deleteImage(String email, String imageUrl);
}
