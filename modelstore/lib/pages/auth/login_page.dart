import 'package:flutter/material.dart';
import 'package:modelstore/pages/auth/register_page.dart';
import 'package:modelstore/utilities/firebase/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Подключить сервис авторизации
  final authService = AuthService();

  // Текстовые контроллеры для ввода данных
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Функция для кнопки авторизации
  void _login() async {
    // Подготовка данных
    final email = emailController.text;
    final password = passwordController.text;

    // Попытка авторизации
    try {
      await authService.signInEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Электронная почта'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Пароль'),
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('Авторизация'),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            ),
            child: const Center(
              child: Text('Еще не зарегистрированы? Создайте аккаунт'),
            ),
          ),
        ],
      ),
    );
  }
}
