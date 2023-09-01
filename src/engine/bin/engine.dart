import 'package:engine/bitboard.dart';
import 'package:engine/board.dart';
import 'package:engine/constants.dart';

void main(List<String> arguments) {
  var board = Board.startingPosition;

  board.printBoard(fillEmptySquares: false);
}
