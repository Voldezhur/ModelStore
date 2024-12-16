import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // Sign in email password
  Future<UserCredential> signInEmailPassword(String email, String password) async {
    try {
      // Попытка авторизации
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // Если ааторизация прошла,
      // Создаем документ пользователя в firestore, если его еще не было
      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up email password
  Future<UserCredential> createUser(String username, String email, String password) async {
    // Сначала пробуем зарегистрироваться в firebase
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // Если регистрация прошла,
    // Создаем документ пользователя в firestore
    _fireStore.collection('users').doc(userCredential.user!.uid).set({
      'uid': userCredential.user!.uid,
      'email': email,
    });

    // Добавляем запись о пользователе в БД Postgres
    ApiService().addUser({
      "username": username,
      "email": email.toLowerCase(),
    });

    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
