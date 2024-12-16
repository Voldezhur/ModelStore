import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/pages/chat/chat_list.dart';
import 'package:modelstore/pages/chat/chat_page.dart';
import 'package:modelstore/utilities/firebase/auth_service.dart';

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

  void _goToChat() {
    // Если айди пользователя 1 (пользователь - администратор),
    // То показываем список всех чатов
    if (currentUser!.userId == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatList()),
      );
    }
    // Иначе показываем только чат с администратором
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatPage(
            recipientEmail: 'voldezhur@gmail.com',
            recipientId: 'qvmB6VvEvKbPg5n3JqcUE0J9eHo2',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Имя пользователя: ${currentUser!.username}",
                  style: const TextStyle(fontSize: 21),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  "Электронная почта: ${currentUser!.email}",
                  style: const TextStyle(fontSize: 21),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  "Код пользователя: ${currentUser!.userId.toString()}",
                  style: const TextStyle(fontSize: 21),
                ),
                ElevatedButton(
                  onPressed: _goToChat,
                  child: currentUser!.userId == 1
                      ? const Text(
                          'Открыть чат',
                        )
                      : const Text('Открыть чат с администрацией'),
                )
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: const Text('Выйти из аккаунта'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
