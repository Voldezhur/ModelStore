/*

  Прослушивает изменения state авторизации

  unauthenticated -> login page
  authenticated -> main page

*/

import 'package:flutter/material.dart';
import 'package:modelstore/pages/auth/login_page.dart';
import 'package:modelstore/pages/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

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
          return const MainPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
