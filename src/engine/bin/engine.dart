import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';

int maskPawnAttacks(color, square) {
  var bitboard = 0;
  var attacks = 0;

  bitboard = setBit(bitboard, square);

  if (color == Color.white) {
    if (((bitboard >> 7) & NOT_A_FILE) > 0) {
      attacks |= bitboard >> 7;
    }
    if (((bitboard >> 9) & NOT_H_FILE) > 0) {
      attacks |= bitboard >> 9;
    } else {
      if (((bitboard << 7) & NOT_H_FILE) > 0) {
        attacks |= bitboard << 7;
      }
      if (((bitboard << 9) & NOT_A_FILE) > 0) {
        attacks |= bitboard << 9;
      }
    }
  }

  return attacks;
}

void main(List<String> arguments) {
  var bitboard = 0;

  bitboard = maskPawnAttacks(Color.white, Squares.d4);
  printBoard(bitboard, color: Color.white);
}
