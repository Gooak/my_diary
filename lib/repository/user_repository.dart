import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_diary/model/user_model.dart';

//로그인시 유저 정보가져오는 Repository
class UserRepository {
  static Future<UserInformation> loginUser(String email) async {
    var data = await FirebaseFirestore.instance.collection('UserInfo').where('email', isEqualTo: email).get();
    return UserInformation.fromJson(data.docs.first.data());
  }
}
