import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/Home.dart';
import 'view/login_page.dart/singIn_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.hasData) {
          return const Home();
        } else {
          return const SigninPage();
        }
      },
    );
  }
}
