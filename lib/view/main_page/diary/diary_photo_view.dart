import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:my_little_memory_diary/components/snack_bar.dart';
import 'package:path_provider/path_provider.dart';

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Center(
              child: ExtendedImage.network(
                imageUrl,
                fit: BoxFit.contain,
                cache: true,
                cacheMaxAge: const Duration(days: 3),
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: 0.9,
                    animationMinScale: 0.7,
                    maxScale: 5.0,
                    animationMaxScale: 8.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: true,
                    initialAlignment: InitialAlignment.center,
                  );
                },
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return const SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case LoadState.completed:
                      return null;
                    case LoadState.failed:
                      return const SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Icon(Icons.close),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 25, 5, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackButton(
                color: Colors.white,
              ),
              IconButton(
                onPressed: () async {
                  await downloadImage(imageUrl, context);
                },
                icon: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> downloadImage(String imageURL, BuildContext context) async {
    try {
      var response = await Dio().get(imageURL, options: Options(responseType: ResponseType.bytes));
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Uint8List? imageData = response.data;
      if (imageData != null) {
        final file = await File(filePath).writeAsBytes(imageData);
        await Gal.putImage(file.path);
      }
      if (context.mounted) {
        showCustomSnackBar(context, '이미지를 저장하였습니다!');
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackBar(context, '이미지 저장을 실패했습니다');
      }
    }
  }
}
