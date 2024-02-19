import 'package:cloud_firestore/cloud_firestore.dart';

class UserInformation {
  String? userName;
  String? email;
  String? device;
  Timestamp? joinDate;

  UserInformation({
    this.userName,
    this.email,
    this.device,
    this.joinDate,
  });

  //시리얼라이즈 함수
  factory UserInformation.fromJson(Map<String, dynamic> json) {
    return UserInformation(
      userName: json['userName'] == null ? '' : json['userName'] as String,
      email: json['email'] == null ? '' : json['email'] as String,
      device: json['device'] == null ? '' : json['device'] as String,
      joinDate: json['joinDate'] == null ? null : json['joinDate'] as Timestamp,
    );
  }
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'device': device,
        'joinDate': joinDate,
      };
}
