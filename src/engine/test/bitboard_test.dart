import 'dart:math';
import 'package:test/test.dart';

import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';

int actualGetBit(int value, int square) {
  return (value >> square) & 1;
}

void main() {

  test('Test BitBoard.getBit()', () {
  var bitBoard = BitBoard(0);
    expect(bitBoard.getBit(Squares.a1),
        equals(actualGetBit(bitBoard.value, Squares.a1)));
    expect(bitBoard.getBit(Squares.b1),
        equals(actualGetBit(bitBoard.value, Squares.b1)));
    expect(bitBoard.getBit(Squares.c1),
        equals(actualGetBit(bitBoard.value, Squares.c1)));
  });

  test('Test BitBoard.setBit() and BitBoard.popBit()', () {
    var bitBoard = BitBoard(0);

    // A list containing random 1's and 0's
    final randomSquareValues =
        List.generate(64, (index) => Random().nextInt(2));

    // Set the values of the new bitboard according to the randomSquareValues list
    for (var index = 0; index < randomSquareValues.length; index++) {
      final randomSquareValue = randomSquareValues[index];

      if (randomSquareValue == 1) {
        bitBoard = bitBoard.setBit(index);
      } else {
        bitBoard = bitBoard.popBit(index);
      }
    }

    // Read the values of each bit and see if the value is correct
    for (var index = 0; index < randomSquareValues.length; index++) {
      final expectedValue = randomSquareValues[index];
      final actualValue = actualGetBit(bitBoard.value, index);

      expect(actualValue, equals(expectedValue));
    }
  });
}
