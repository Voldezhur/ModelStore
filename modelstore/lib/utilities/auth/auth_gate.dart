/*

  Прослушивает изменения state авторизации

  unauthenticated -> login page
  authenticated -> main page

*/

import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/pages/auth/login_page.dart';
import 'package:modelstore/pages/main_page.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Загрузка
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Если имеется сессия на данный момент
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          _updateUser(true, email: snapshot.data!.session!.user.email!);
          return const MainPage();
        } else {
          _updateUser(false);
          return const LoginPage();
        }
      },
    );
  }
}
