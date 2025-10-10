import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryModel {
  String? id;
  String date;
  String text;
  String imageUrl;
  String imagePath;
  Timestamp? timestamp;
  DiaryModel({
    this.id,
    required this.date,
    required this.text,
    required this.imageUrl,
    required this.imagePath,
    required this.timestamp,
  });
  //시리얼라이즈 함수
  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      date: json['date'] == null ? '' : json['date'] as String,
      text: json['text'] == null ? '' : json['text'] as String,
      imageUrl: json['imageUrl'] == null ? '' : json['imageUrl'] as String,
      imagePath: json['imagePath'] == null ? '' : json['imagePath'] as String,
      timestamp:
          json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
    );
  }

  factory DiaryModel.fromDocumentSnapshot(DocumentSnapshot json) {
    return DiaryModel(
      id: json.id,
      date: json['date'] == null ? '' : json['date'] as String,
      text: json['text'] == null ? '' : json['text'] as String,
      imageUrl: json['imageUrl'] == null ? '' : json['imageUrl'] as String,
      imagePath: json['imagePath'] == null ? '' : json['imagePath'] as String,
      timestamp:
          json['timestamp'] == null ? null : json['timestamp'] as Timestamp,
    );
  }
  Map<String, dynamic> toJson() => {
        'date': date,
        'text': text,
        'imageUrl': imageUrl,
        'imagePath': imagePath,
        'timestamp': timestamp,
      };
}
