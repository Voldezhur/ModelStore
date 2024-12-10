import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/utilities/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfilePage> {
  final authService = AuthService();

  void _logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(currentUser!.userId.toString()),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.1,
                ),
                Text(currentUser!.username),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _logout,
            child: const Text('Выйти из аккаунта'),
          ),
        ],
      )),
    );
  }
}
