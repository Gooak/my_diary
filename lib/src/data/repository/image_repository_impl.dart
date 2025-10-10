import 'dart:io';

import 'package:my_little_memory_diary/src/data/remote_data_source/image_storage_data_source.dart';
import 'package:my_little_memory_diary/src/domain/error/exceptions.dart';
import 'package:my_little_memory_diary/src/domain/repository/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageStorageDataSource _dataSource;
  ImageRepositoryImpl(this._dataSource);

  @override
  Future<List<String>> uploadImage(String email, File image) async {
    try {
      return await _dataSource.uploadImage(email, image);
    } catch (e) {
      throw ErrorException('이미지 업로드에 실패하였습니다.');
    }
  }

  @override
  Future<void> deleteImage(String email, String imageUrl) async {
    try {
      return await _dataSource.deleteImage(email, imageUrl);
    } catch (e) {
      throw ErrorException('이미지 삭제에 실패하였습니다.');
    }
  }
}
