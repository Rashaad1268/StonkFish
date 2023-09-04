import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

late ListSet<int> pawnAttacks;

BitBoard maskPawnAttacks(int square, {required Side side}) {
  var bitboard = BitBoard(0).setBit(square);
  var attacks = BitBoard(0);

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

void init() {
  for (var square=0; square < 64; square++) {
    
  }
}
