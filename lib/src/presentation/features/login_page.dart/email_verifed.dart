import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerified extends StatelessWidget {
  const EmailVerified({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return Container();
  }
}
