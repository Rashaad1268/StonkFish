import "dart:io" show stdout;

import "package:engine/constants.dart" show Color;

int setBit(int bitboard, int square) {
  return bitboard | (1 << square);
}

int getBit(int bitboard, square) {
  return (bitboard >> square) & 1;
}

int popBit(int bitboard, square) {
  if (getBit(bitboard, square) != 0) {
    return bitboard ^ (1 << square);
  } else {
    return 0;
  }
}

printBoard(bitboard, {Color color = Color.white}) {
  final isWhite = color == Color.white;

  print('');

  for (var rank = 0; rank < 8; rank++) {
    for (var file = 0; file < 8; file++) {
      // Invert everything if the players color is black
      final square = isWhite ? rank * 8 + file : 63 - (rank * 8 + file);

      if (file == 0) {
        stdout.write("${isWhite ? 8 - rank : rank + 1}   ");
      }

      stdout.write('${getBit(bitboard, square) != 0 ? 1 : 0} ');
    }
    stdout.write('\n');
  }

  stdout.write(isWhite ? '\n    a b c d e f g h' : '\n    h g f e d c b a');
  print('\n');
}
