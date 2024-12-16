import 'package:flutter/material.dart';
import 'package:modelstore/utilities/firebase/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Подключить сервис авторизации
  final authService = AuthService();

  // Текстовые контроллеры для ввода данных
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _signUp() async {
    // Подготовка данных
    final username = usernameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Проверка совпадения паролей
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароли не совпадают')),
      );
      return;
    }

    // Попытка создания аккаунта
    try {
      await authService.createUser(username, email, password);

      if (mounted) {
        Navigator.pop(context);
      }
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
        title: const Text('Регистрация'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Имя пользователя'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Электронная почта'),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Пароль'),
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(labelText: 'Подтвердите пароль'),
          ),
          ElevatedButton(
            onPressed: _signUp,
            child: const Text('Создать аккаунт'),
          ),
        ],
      ),
    );
  }
}
