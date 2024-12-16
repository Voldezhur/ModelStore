import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modelstore/utilities/auth/auth_gate.dart';

import 'firebase_options.dart';

void main() async {
  // Инициалиация firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Model Marketplace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          surface: const Color.fromARGB(99, 41, 55, 75),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
