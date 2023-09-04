import 'package:flutter/material.dart';
import 'package:ui/widgets/chessBoard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("StonkFish UI"),
      ),
      body: const Center(
        child: ChessBoard(),
      ),
    );
  }
}
