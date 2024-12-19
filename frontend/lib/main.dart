import 'package:flutter/material.dart';
import 'package:smart_bite/screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Smart Bite',
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


