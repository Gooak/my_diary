import 'package:flutter/material.dart';

class DesignInputDecoration {
  final String? hintText;
  final Widget? icon;
  final double circular;
  final String? hintCount;
  DesignInputDecoration({required this.hintText, required this.icon, required this.circular, required this.hintCount});

  InputDecoration get inputDecoration => InputDecoration(
        prefixIcon: icon,
        contentPadding: const EdgeInsets.all(10),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(circular),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(circular),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(circular),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(circular),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(circular),
        ),
        hintText: hintText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(circular),
        ),
        counterText: hintCount,
      );
}
