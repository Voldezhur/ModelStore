import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modelstore/models/message.dart';

class ChatService {
  // Получаем инстанции
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Отправить сообщение
  Future<void> sendMessage(String recipientId, String message) async {
    // Получить информацию о авторизованном пользователе
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp sentAt = Timestamp.now();

    // Создание нового сообщения
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      recipientId: recipientId,
      message: message,
      sentAt: sentAt,
    );

    // Создание уникального айди комнаты чата
    List<String> ids = [currentUserId, recipientId];
    // Сортируем, чтобы у двух пользователей всегда была одна комната,
    // Вне зависимости от того, кто отправил сообщение, а кто получил
    ids.sort();
    String chatRoomId = ids.join('_'); // Объединяем айди пользователей, чтобы получить айди комнаты

    // Создаем комнату в бд и добавляем новое сообщение в нее
    await _fireStore.collection('chatrooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
  }

  // Получить сообщения
  // Не важно, в каком порядке аргументы,
  // Для двух пользователей айди комнаты всегда один
  Stream<QuerySnapshot> getMessages(String userId1, String userId2) {
    // Собираем айди комнаты из айди пользователей, как при отправке сообщения
    List<String> ids = [userId1, userId2];
    ids.sort();
    String chatRoomId = ids.join('_');

    // Получаем сообщения в комнате чата, отсортированные по времени отправки
    return _fireStore.collection('chatrooms').doc(chatRoomId).collection('messages').orderBy('sentAt', descending: false).snapshots();
  }
}
