import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/core/services/image_service.dart';

class FullScreenImagePage extends ConsumerWidget {
  final String imageUrl;
  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  bool result =
                      await ref.read(imageProvider).downloadImage(imageUrl);
                  if (result == true) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(("이미지를 저장하였습니다."))),
                    );
                  } else {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(("이미지를 저장을 실패하였습니다."))),
                    );
                  }
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
}
