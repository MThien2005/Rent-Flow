import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import file bạn vừa tạo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản Lý Nhà Trọ',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(), // Trỏ thẳng vào HomeScreen
      debugShowCheckedModeBanner: false, // Tắt chữ DEBUG góc phải
    );
  }
}