import 'package:flutter/material.dart';
import 'package:my_little_memory_diary/src/presentation/common/theme/design_input_decoration.dart';

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
          if (cancel != '')
            ElevatedButton(
              onPressed: cancelAction,
              child: Text(cancel),
            ),
        ],
      );
    }),
  );
}

void textDialogFunc(
    {required BuildContext context,
    required String title,
    required String text,
    required String cancel,
    required String enter,
    required TextEditingController feedbackController,
    required String hintText,
    required Icon? icon,
    required String? hintCount,
    required double circualr,
    required int maxLength,
    required GestureTapCallback cancelAction,
    required GestureTapCallback enterAction}) {
  showDialog(
    context: context,
    barrierDismissible: true, //바깥 영역 터치시 닫을지 여부 결정
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: feedbackController,
              maxLength: maxLength,
              decoration: DesignInputDecoration(hintText: hintText, icon: icon, circular: circualr, hintCount: hintCount).inputDecoration,
            ),
          ],
        ),
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
