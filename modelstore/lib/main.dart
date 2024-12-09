import 'package:flutter/material.dart';
import 'package:modelstore/utilities/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Инициализация supabase
  await Supabase.initialize(
    url: 'https://yxsqqsngscoxbsfvgjqs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl4c3Fxc25nc2NveGJzZnZnanFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM2NzA5OTEsImV4cCI6MjA0OTI0Njk5MX0.ddVL6hY2LFt3fR85zgAqh33W3PhzZC1CWJK-cIOTDQI',
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
