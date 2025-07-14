// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
