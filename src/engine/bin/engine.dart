import 'dart:io';

import 'package:engine/engine.dart';

// import 'package:engine/attacks_cache.dart';
void main(List<String> arguments) {
  initAttacks();

  var board = Board.empty;
  board.pieceBitBoards[PieceType.wPawn] = BitBoard(0).setBit(Squares.f7);
  pawnAttacks[0][getLs1bIndex(board.pieceBitBoards[PieceType.wPawn]!.value)].printBoard();
  print(pawnAttacks[0][getLs1bIndex(board.pieceBitBoards[PieceType.wPawn]!.value)].has(Squares.e8));
  print(board.isSquareAttacked(Squares.e8, Side.white));
  // pawnAttacks[0][Squares.f7].printBoard();
}
