import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarModel {
  String date;
  String weather;
  String mood;
  Timestamp? timestamp;
  int? calendarCount;
  CalendarModel({
    required this.date,
    required this.weather,
    required this.mood,
    required this.timestamp,
    required this.calendarCount,
  });
  //시리얼라이즈 함수
  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      date: json['date'] == null ? '' : json['date'] as String,
      weather: json['weather'] == null ? '' : json['weather'] as String,
      mood: json['mood'] == null ? '' : json['mood'] as String,
      timestamp: json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
      calendarCount: json['calendarCount'] == null ? 0 : json['calendarCount'] as int,
    );
  }

  factory CalendarModel.fromDocumentSnapshot(DocumentSnapshot json) {
    return CalendarModel(
      date: json['date'] == null ? '' : json['date'] as String,
      weather: json['weather'] == null ? '' : json['weather'] as String,
      mood: json['mood'] == null ? '' : json['mood'] as String,
      timestamp: json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
      calendarCount: json['calendarCount'] == null ? 0 : json['calendarCount'] as int,
    );
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'weather': weather,
        'mood': mood,
        'timestamp': timestamp,
        'calendarCount': calendarCount,
      };
}
