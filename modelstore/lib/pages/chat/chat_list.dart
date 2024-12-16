import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modelstore/models/user.dart';
import 'package:modelstore/pages/chat/chat_page.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список чатов'),
      ),
      body: _buildUserList(),
    );
  }

  // Строим список пользователей, кроме уже авторизованного
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  // Карточка чата
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Проверка, чтобы не отображать уже авторизованного пользователя
    if (data['email'] != currentUser!.email) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          tileColor: Theme.of(context).primaryColor,
          title: Text(data['email']),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    recipientEmail: data['email'],
                    recipientId: data['uid'],
                  ),
                ));
          },
        ),
      );
    }
    return Container();
  }
}
