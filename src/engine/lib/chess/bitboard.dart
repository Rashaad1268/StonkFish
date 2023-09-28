import "dart:io" show stdout;

import 'package:engine/chess/enums.dart';

class BitBoard {
  /*
  BitBoard | BitBoard is union, combines all of the bits
  BitBoard & BitBoard is interection, if both bits are 1 the result is 1 else 0
  */
  final int value;
  final PieceType? pieceType;
  const BitBoard(this.value, {this.pieceType});

  static const full = BitBoard(0xffffffffffffffff);
  static const lightSquares = BitBoard(0x55AA55AA55AA55AA);
  static const darkSquares = BitBoard(0xAA55AA55AA55AA55);
  static const diagonal = BitBoard(0x8040201008040201);
  static const antidiagonal = BitBoard(0x0102040810204080);
  static const corners = BitBoard(0x8100000000000081);
  static const center = BitBoard(0x0000001818000000);
  static const backranks = BitBoard(0xff000000000000ff);

  BitBoard setBit(int square) {
    assert(square >= 0 && square < 64);
    return BitBoard(value | (1 << square));
  }

  int getBit(int square) {
    assert(square >= 0 && square < 64);
    return (value >> square) & 1;
  }

  bool has(int square) {
    assert(square >= 0 && square < 64);
    return getBit(square) == 1;
  }

  BitBoard popBit(int square) {
    assert(square >= 0 && square < 64);

    return BitBoard(value & ~(1 << (square)));
  }

  /// Bitwise right shift
  BitBoard shr(int shift) {
    if (shift >= 64) return BitBoard(0);
    if (shift > 0) return BitBoard(value >>> shift);
    return this;
  }

  BitBoard operator >>(int shift) => shr(shift);

  /// Bitwise left shift
  BitBoard shl(int shift) {
    if (shift >= 64) return BitBoard(0);
    if (shift > 0) return BitBoard(value << shift);
    return this;
  }

  BitBoard operator <<(int shift) => shl(shift);

  BitBoard operator -() => BitBoard(-value);

  BitBoard xor(BitBoard other) => BitBoard(value ^ other.value);
  BitBoard operator ^(BitBoard other) => BitBoard(value ^ other.value);

  BitBoard union(BitBoard other) => BitBoard(value | other.value);
  BitBoard operator |(BitBoard other) => BitBoard(value | other.value);

  BitBoard intersect(BitBoard other) => BitBoard(value & other.value);
  BitBoard operator &(BitBoard other) => BitBoard(value & other.value);

  BitBoard minus(BitBoard other) => BitBoard(value - other.value);
  BitBoard operator -(BitBoard other) => BitBoard(value - other.value);

  BitBoard operator ~() => BitBoard(~value);
  BitBoard complement() => BitBoard(~value);

  BitBoard operator *(int other) => BitBoard(value * other);

  BitBoard diff(BitBoard other) => BitBoard(value & ~other.value);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BitBoard &&
            other.runtimeType == runtimeType &&
            other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return "BitBoard($value)";
  }

  bool notEmpty() => value != 0;

  printBoard({bool showBoardValue = true}) {
    print('');

    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square = rank * 8 + file;

        if (file == 0) {
          stdout.write("${8 - rank}  | ");
        }

        stdout.write('${getBit(square)} ');
      }
      stdout.write('\n');
    }

    stdout.write('   ------------------');
    stdout.write('\n     a b c d e f g h\n');
    if (showBoardValue) {
      print('\nBitBoard Value: $value\n');
    }
  }
}
