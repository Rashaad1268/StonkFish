import 'dart:io';

import 'package:engine/engine.dart';

void interactiveCliMatch(Board board) {
  print('\nEnter Move >>>');

  while (true) {
    final move = stdin.readLineSync()?.trim();

    if (move == null || move.length < 4) {
      print("Invalid move bruh");
      continue;
    }

    final from = squareFromAlgebraic(move.substring(0, 2));
    final to = squareFromAlgebraic(move.substring(2, 4));

    Move? moveToMake;

    try {
      moveToMake = board
          .generateLegalMoves()
          .firstWhere((m) => m.from == from && m.to == to);
    } catch (error) {
      if (error is StateError) {
        print("\nInvalid move bruh\nThe correct format is {from}{to}\n");
        continue;
      }
    }

    try {
      board.makeMove(moveToMake!);
    } catch (error) {
      if (error is ArgumentError) {
        print(error.message);
      }
    }

    board.printBoard();
  }
}
