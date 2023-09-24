import 'dart:io';

import 'package:engine/engine.dart';

void main(List<String> arguments) {
  initAttacks();

  var board = Board.startingPosition;
// board.pieceBitBoards[PieceType.wPawn]!.printBoard();

  board.printBoard();
  print('\nEnter Move >>>');

  while (true) {
    final move = stdin.readLineSync();

    if (move == null || move.length != 4) {
      print("Invalid move bruh");
      continue;
    }

    try {
      board.makeMove(move);
    } catch (error) {
      if (error is ArgumentError) {
        print(error.message);
      }
    }

    board.printBoard();
    print("IS check: ${board.isCheck}");
  }
}
