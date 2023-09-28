import 'package:engine/engine.dart';
import 'package:flutter/material.dart';
import 'screens/homepage.dart';

void main() {
  initAttacks();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'StonkFish chess engine',
      home: HomePage(),
    );
  }
}
