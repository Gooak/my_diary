import 'package:flutter/material.dart';

class DesignInputDecoration {
  final String? hintText;
  final Widget? icon;

  DesignInputDecoration({required this.hintText, required this.icon});

  InputDecoration get inputDecoration => InputDecoration(
        prefixIcon: icon,
        contentPadding: const EdgeInsets.all(10),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: hintText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(5),
        ),
      );
}
