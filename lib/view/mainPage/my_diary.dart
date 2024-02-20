import 'package:flutter/material.dart';

class MyDiary extends StatefulWidget {
  const MyDiary({super.key});

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('일기를 작성해주세요.'),
      ),
    );
  }
}
