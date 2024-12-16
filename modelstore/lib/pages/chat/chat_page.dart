import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modelstore/utilities/firebase/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.recipientEmail, required this.recipientId});

  final String recipientEmail;
  final String recipientId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController(); // Ввод сообщения
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Метод отправки сообщения
  void _sendMessage() async {
    // Проверка, что сообщение не пустое
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.recipientId,
        messageController.text,
      );
      // Очистка ввода после отправки сообщения
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientEmail),
      ),
      body: Column(
        children: [
          // Сообщения
          Expanded(
            child: _buildMessageList(),
          ),

          // Ввод пользователя
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Список сообщений
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.recipientId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        // Проверка ошибок
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Загрузка...');
        }

        // Возвращаем список сообщений
        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  // Сообщение
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // Сообщения ставим у левого или правого края экрана,
    // В зависимости от того, отправил сообщение сам пользователь или собеседник
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(data['senderEmail']),
          Text(data['message']),
        ],
      ),
    );
  }

  // Ввод пользователя
  Widget _buildMessageInput() {
    return Row(
      children: [
        // Ввод
        Expanded(
          child: TextField(
            controller: messageController,
            obscureText: false,
            decoration: const InputDecoration(
              hintText: 'Сообщение',
              hintFadeDuration: Duration(milliseconds: 200),
            ),
          ),
        ),
        // Кнопка отправления
        IconButton(
          onPressed: _sendMessage,
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}