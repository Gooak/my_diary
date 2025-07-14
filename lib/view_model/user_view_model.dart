import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_little_memory_diary/model/user_model.dart';
import 'package:my_little_memory_diary/server_repository/user_repository.dart';

class UserProvider extends ChangeNotifier {
  UserInformation? _user = UserInformation();
  UserInformation? get user => _user;

  DateTime joinDate = DateTime.now();

  UserProvider(String email) {
    if (email.isNotEmpty) {
      loginUser(email);
    }
  }

  Future<void> loginUser(String email) async {
    if (email == "null") {
      return;
    } else {
      _user = await UserRepository.loginUser(email);
      if (_user != null) {
        DateTime myDate = _user!.joinDate!.toDate();
        joinDate = DateTime(myDate.year, myDate.month, myDate.day);
      }
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    _user = null;
    notifyListeners();
  }

  Future<void> deleteUser(String email) async {
    await UserRepository.deleteUser(email);
    await logOut();
  }
}
