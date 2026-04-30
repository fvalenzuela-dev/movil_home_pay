// Main entry point for the movil_home_pay Flutter application.
//
// This file initializes the application structure and sets up
// essential configurations. Integration with Clerk Authentication
// and backend API services are configured via environment variables.
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Pay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('Home Pay Project Initialized')),
      ),
    );
  }
}