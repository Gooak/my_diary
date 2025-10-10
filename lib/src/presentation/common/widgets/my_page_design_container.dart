import 'package:flutter/material.dart';

InkWell customButtonContainer(
    {required BuildContext context,
    required Size screenSize,
    required String leftText,
    required String rightText,
    required GestureTapCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 60,
      width: screenSize.width,
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
            rightText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
