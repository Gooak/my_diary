import 'package:flutter/material.dart';

void dialogFunc(
    {required BuildContext context,
    required String title,
    required String text,
    required String cancel,
    required String enter,
    required GestureTapCallback cancelAction,
    required GestureTapCallback enterAction}) {
  showDialog(
    context: context,
    barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          ElevatedButton(
            onPressed: enterAction,
            child: Text(enter),
          ),
          ElevatedButton(
            onPressed: cancelAction,
            child: Text(cancel),
          ),
        ],
      );
    }),
  );
}
