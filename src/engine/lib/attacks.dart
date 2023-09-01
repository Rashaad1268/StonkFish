import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';

BitBoard maskPawnAttacks(Side side, int square) {
  var bitboard = BitBoard(0);
  var attacks = BitBoard(0);

  bitboard = bitboard.setBit(square);

  if (side == Side.white) {
    if (((bitboard >> 7) & NOT_A_FILE).value > 0) {
      attacks |= bitboard >> 7;
    }
    if (((bitboard >> 9) & NOT_H_FILE).value > 0) {
      attacks |= bitboard >> 9;
    } else {
      if (((bitboard << 7) & NOT_H_FILE).value > 0) {
        attacks |= bitboard << 7;
      }
      if (((bitboard << 9) & NOT_A_FILE).value > 0) {
        attacks |= bitboard << 9;
      }
    }
  }

  return attacks;
}
