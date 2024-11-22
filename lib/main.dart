import 'package:flutter/material.dart';
import 'bottomnavigationbar.dart'; // Import your BottomNavigationBar widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Jobs App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavBar(),  // Use BottomNavBar as the home widget
    );
  }
}


