import 'dart:io';

import 'package:engine/engine.dart';

// void main(List<String> arguments) {
// init();
// var board = Board.startingPosition;
// // board.pieceBitBoards[PieceType.wPawn]!.printBoard();

// board.printBoard();
// print('\nEnter Move >>>');

// while (true) {
//   final move = stdin.readLineSync();

//   if (move == null || move.length != 4) {
//     print("Invalid move bruh");
//     continue;
//   }

//   try {
//     board.makeMove(move);
//   } catch (error) {
//     if (error is ArgumentError) {
//       print(error.message);
//     }
//   }

//   board.printBoard();
// }
// }

void main(List<String> arguments) {
  final board = Board.startingPosition;
  board.pieceBitBoards[PieceType.wPawn]!.printBoard();
  // genRookAttacksOnTheFly(Squares.d4, 0).printBoard();
  // genRookAttacksOnTheFly(
  //         Squares.h1, (board.whitePieces | board.blackPieces).value)
  //     .printBoard();

  // (board.whitePieces | board.blackPieces).printBoard();
  // setOccupancy(4095, countBits(maskRookAttacks(Squares.a1)),
  //         maskRookAttacks(Squares.a1))
  //     .printBoard();
  // assert(setOccupancy(
  //     0, countBits(maskRookAttacks(Squares.a1)), maskRookAttacks(Squares.a1)).value == 0);

  print(getRandomNumber());
  print(getRandomNumber());
  print(getRandomNumber());
  print(getRandomNumber());
  print(getRandomNumber());
  print(getRandomNumber());
}
