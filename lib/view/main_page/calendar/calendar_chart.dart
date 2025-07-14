import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CalendarChart extends StatefulWidget {
  const CalendarChart({super.key, required this.eventChart});
  final QuerySnapshot eventChart;

  @override
  State<StatefulWidget> createState() => _CalendarChartState();
}

class _CalendarChartState extends State<CalendarChart> {
  int touchedIndex = 0;
  List<PieChartSectionData> eventChartList = [];

  var emotion = <Map<String, dynamic>>[
    {'mood': 'happy', 'count': 0, 'Color': Colors.orange, 'index': 0},
    {'mood': 'happiness', 'count': 0, 'Color': Colors.pink, 'index': 1},
    {'mood': 'tired', 'count': 0, 'Color': Colors.purple, 'index': 2},
    {'mood': 'depressed', 'count': 0, 'Color': Colors.cyan, 'index': 3},
    {'mood': 'tremble', 'count': 0, 'Color': Colors.yellow, 'index': 4},
    {'mood': 'angry', 'count': 0, 'Color': Colors.red, 'index': 5},
    {'mood': 'sad', 'count': 0, 'Color': Colors.blue, 'index': 6},
  ];

  @override
  void initState() {
    super.initState();
    for (var eventItem in widget.eventChart.docs) {
      switch (eventItem['moodImage']) {
        case 'happy':
          emotion[0]['count'] = emotion[0]['count']! + 1;
          break;
        case 'happiness':
          emotion[1]['count'] = emotion[1]['count']! + 1;
          break;
        case 'tired':
          emotion[2]['count'] = emotion[2]['count']! + 1;
          break;
        case 'depressed':
          emotion[3]['count'] = emotion[3]['count']! + 1;
          break;
        case 'tremble':
          emotion[4]['count'] = emotion[4]['count']! + 1;
          break;
        case 'angry':
          emotion[5]['count'] = emotion[5]['count']! + 1;
          break;
        default:
          emotion[6]['count'] = emotion[6]['count']! + 1;
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '내 기분 통계',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Text('이번 달 중에 일기를 ${widget.eventChart.docs.length}번 작성 하셨습니다!'),
          const SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  // pieTouchData: PieTouchData(
                  //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  //     setState(() {
                  //       if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                  //         touchedIndex = -1;
                  //         return;
                  //       }
                  //       touchedIndex = emotion[pieTouchResponse.touchedSection!.touchedSectionIndex]['index'];
                  //       print(touchedIndex);
                  //     });
                  //   },
                  // ),
                  // borderData: FlBorderData(
                  //   show: false,
                  // ),
                  // sectionsSpace: 0,
                  // centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(emotion.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: emotion[i]['Color'],
        value: double.parse(emotion[i]['count'].toString()),
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff), shadows: shadows),
        badgeWidget: _Badge('images/${emotion[i]['mood']}.png', size: widgetSize, borderColor: Colors.black),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: ExtendedImage.asset(
          svgAsset,
        ),
      ),
    );
  }
}
