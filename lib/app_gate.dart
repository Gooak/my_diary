import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_little_memory_diary/src/presentation/features/home.dart';
import 'package:my_little_memory_diary/src/presentation/features/login_page.dart/email_verifed.dart';
import 'package:my_little_memory_diary/src/presentation/features/login_page.dart/singIn_page.dart';
import 'package:my_little_memory_diary/src/presentation/features/providers/user_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final email = userSnapshot.data?.email;
        Future.microtask(() {
          ref.read(userNotifierProvider.notifier).loginUser(email!);
        });
        return Consumer(
          builder: (context, ref, _) {
            final user = ref.watch(userNotifierProvider).value;
            if (!userSnapshot.hasData) {
              return const SigninPage();
            } else {
              if (user == null || user.email == null) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return userSnapshot.data!.emailVerified == false
                    ? const EmailVerified()
                    : const Home();
              }
            }
          },
        );
      },
    );
  }
}
