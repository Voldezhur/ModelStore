/*

  Прослушивает изменения state авторизации

  unauthenticated -> login page
  authenticated -> main page

*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/pages/auth/login_page.dart';
import 'package:modelstore/pages/main_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  void _updateUser(bool loggedIn, {String email = ''}) async {
    if (loggedIn) {
      currentUser = await ApiService().getUserByEmail(email);
    } else {
      currentUser = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Если пользователь авторизован
        if (snapshot.hasData) {
          _updateUser(true, email: snapshot.data!.email!);
          return const MainPage();
        }

        // Если нет авторизованного пользователя
        else {
          _updateUser(false);
          return const LoginPage();
        }
      },
    );
  }
}
