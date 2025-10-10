import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  final picker = ImagePicker();

  // 이미지 선택
  Future<File?> getImage(
      {ImageSource imageSource = ImageSource.gallery,
      int imageQuality = 25}) async {
    try {
      final image = await picker.pickImage(
          source: imageSource, imageQuality: imageQuality);
      return File(image!.path);
    } catch (e, st) {
      debugPrint('emage error: $e\n$st');
      return null;
    }
  }

  //이미지 다운로드
  Future<bool> downloadImage(String imageURL) async {
    try {
      var response = await Dio()
          .get(imageURL, options: Options(responseType: ResponseType.bytes));
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Uint8List? imageData = response.data;
      if (imageData != null) {
        final file = await File(filePath).writeAsBytes(imageData);
        await Gal.putImage(file.path);
      }
      return true;
    } catch (e, st) {
      debugPrint('downloadImage error: $e\n$st');
      return false;
    }
  }
}

// 이미지 서비스 프로바이더
final imageProvider = Provider<ImageService>((ref) {
  return ImageService();
});
