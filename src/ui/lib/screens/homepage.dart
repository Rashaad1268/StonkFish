import 'package:flutter/material.dart';
import 'package:ui/widgets/chess_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StonkFish go brrr"),
      ),
      body: const Center(
        child: ChessBoard(),
      ),
    );
  }
}
