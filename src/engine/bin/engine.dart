import 'dart:io' show stdin;

import 'package:engine/bitboard.dart';
import 'package:engine/board.dart';
import 'package:engine/constants.dart';
import 'package:engine/utils.dart';

void main(List<String> arguments) {
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
  }
}
