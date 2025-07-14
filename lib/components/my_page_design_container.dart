import 'package:flutter/material.dart';

InkWell myPageDesignContainer(
    {required BuildContext context,
    required Size scrrenSize,
    required String leftText,
    required String rightTest,
    required GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 60,
      width: scrrenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          Text(
            rightTest,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
