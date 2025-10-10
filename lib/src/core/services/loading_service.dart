import 'package:flutter/material.dart';

class LoadingOverlayService {
  static final LoadingOverlayService _instance =
      LoadingOverlayService._internal();
  factory LoadingOverlayService() => _instance;
  LoadingOverlayService._internal();

  static OverlayEntry? _overlayEntry;

  static void showLoading(BuildContext context) {
    if (_overlayEntry != null) return; // 이미 보여지고 있으면 무시

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: Container(
          color: Colors.black54,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static Future<T> runWithLoading<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    showLoading(context);
    try {
      return await task();
    } finally {
      hideLoading();
    }
  }
}
