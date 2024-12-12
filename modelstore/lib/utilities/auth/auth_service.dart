import 'package:modelstore/utilities/api_handling/api_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in email password
  Future<AuthResponse> signInEmailPassword(
      String email, String password) async {
    return await _supabase.auth
        .signInWithPassword(email: email, password: password);
  }

  // Sign up email password
  Future<AuthResponse> createUser(
      String username, String email, String password) async {
    // Сначала пробуем зарегистрироваться в supabase
    var response =
        await _supabase.auth.signUp(email: email, password: password);

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
    await _supabase.auth.signOut();
  }

  // Get user email
  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
