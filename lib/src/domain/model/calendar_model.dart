import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarModel {
  String date;
  String weather;
  String mood;
  String moodImage;
  Timestamp? timestamp;
  CalendarModel({
    required this.date,
    required this.weather,
    required this.mood,
    required this.moodImage,
    required this.timestamp,
  });
  //시리얼라이즈 함수
  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      date: json['date'] == null ? '' : json['date'] as String,
      weather: json['weather'] == null ? '' : json['weather'] as String,
      mood: json['mood'] == null ? '' : json['mood'] as String,
      moodImage: json['moodImage'] == null ? '' : json['moodImage'] as String,
      timestamp:
          json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
    );
  }

  factory CalendarModel.fromDocumentSnapshot(DocumentSnapshot json) {
    return CalendarModel(
      date: json['date'] == null ? '' : json['date'] as String,
      weather: json['weather'] == null ? '' : json['weather'] as String,
      mood: json['mood'] == null ? '' : json['mood'] as String,
      moodImage: json['moodImage'] == null ? '' : json['moodImage'] as String,
      timestamp:
          json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
    );
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'weather': weather,
        'mood': mood,
        'moodImage': moodImage,
        'timestamp': timestamp,
      };
}
