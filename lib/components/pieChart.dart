import 'package:flutter/material.dart';
import "dart:math" as math;
import 'package:my_little_memory_diary/model/pie_model.dart';

class PieChart extends CustomPainter {
  final List<PieModel> data;
  final double value;

  PieChart(this.data, this.value);
  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = Colors.white;
    double radius = (size.width / 2) * 0.8;
    double startPoint = 0.0;
    for (int i = 0; i < data.length; i++) {
      double count = data[i].count.toDouble();
      count = (count * value + count) - data[i].count;

      double startAngle = 2 * math.pi * (count / 100);
      double nextAngle = 2 * math.pi * (count / 100);
      circlePaint.color = data[i].color;

      canvas.drawArc(
          Rect.fromCircle(center: Offset(size.width / 2, size.width / 2), radius: radius), -math.pi / 2 + startPoint, nextAngle, true, circlePaint);
      startPoint = startPoint + startAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
