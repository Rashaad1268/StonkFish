import 'dart:io';

import 'package:engine/engine.dart';

void interactiveCliMatch(Board board) {
  board.printBoard();
  print('\nEnter Move >>>');

  while (true) {
    final move = UCIParser.parseMove(board, stdin.readLineSync()?.trim() ?? '');

    if (move == null) {
      print("Invalid move bruh");
      continue;
    }

    try {
      board.makeMove(move);
      board.negamax(alpha: -50000, beta: 50000, depth: 4);
      board.makeMove(Eval.bestMove!);
    } catch (error) {
      if (error is ArgumentError) {
        print(error.message);
      }
    }

    board.printBoard();
  }
}
