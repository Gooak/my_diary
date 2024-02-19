import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_diary/Home.dart';
import 'package:my_diary/viewModel/calendar_view_model.dart';
import 'package:my_diary/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'view/login_page.dart/singIn_page.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.hasData) {
          final user = userSnapshot.data!;
          return MultiProvider(
            providers: [
              //  ChangeNotifierProvider<UserProvider>(
              //   create: (context) {
              //     final provider = UserProvider(user.email!);
              //     provider.loginUser(user.email!);
              //     return provider;
              //   },
              // ),
              ChangeNotifierProvider.value(value: UserProvider(user.email!)),
              ChangeNotifierProvider<CalendarViewModel>(create: (context) => CalendarViewModel()),
            ],
            child: const Home(),
          );
        } else {
          return const SigninPage();
        }
      },
    );
  }
}
