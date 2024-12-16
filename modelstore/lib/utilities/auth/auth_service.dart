import 'package:firebase_auth/firebase_auth.dart';
import 'package:modelstore/utilities/api_handling/api_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in email password
  Future<UserCredential> signInEmailPassword(String email, String password) async {
    try {
      // Попытка авторизации
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign up email password
  Future<UserCredential> createUser(String username, String email, String password) async {
    // Сначала пробуем зарегистрироваться в firebase
    var response = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    // Если регистрация прошла,
    // Добавляем запись о пользователе в БД Postgres
    ApiService().addUser({
      "username": username,
      "email": email.toLowerCase(),
    });

    return response;
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
