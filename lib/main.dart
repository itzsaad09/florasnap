import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'presentation/views/home_screen.dart';
import 'presentation/views/result_screen.dart';

void main() {
  runApp(const FloraSnap());
}

class FloraSnap extends StatelessWidget {
  const FloraSnap({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "FloraSnap",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: "Poppins",
        scaffoldBackgroundColor: const Color(0xFFF8FFF5),
      ),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/result', page: () => const ResultScreen()),
      ],
      home: const HomeScreen(),
    );
  }
}