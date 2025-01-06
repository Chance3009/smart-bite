import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const SmartBiteApp());
}

class SmartBiteApp extends StatelessWidget {
  const SmartBiteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartBite',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) =>  HomeScreen(),
        '/profile': (context) =>  ProfileScreen(),
        '/chat': (context) =>  ChatScreen(),
      },
    );
  }
}