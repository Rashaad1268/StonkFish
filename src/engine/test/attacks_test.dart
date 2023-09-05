import 'package:engine/engine.dart';
import 'package:test/test.dart';

void main() {
  test('Test maskPawnAttacks()', () {
    // Test if the masking works for white
    expect(maskPawnAttacks(Squares.a7, side: Side.white),
        equals(BitBoard(0).setBit(Squares.b8)));

    expect(maskPawnAttacks(Squares.h7, side: Side.white),
        equals(BitBoard(0).setBit(Squares.g8)));

    expect(maskPawnAttacks(Squares.b7, side: Side.white),
        equals(BitBoard(0).setBit(Squares.a8).setBit(Squares.c8)));

    // Test if the masking works for black
    expect(maskPawnAttacks(Squares.a2, side: Side.black),
        equals(BitBoard(0).setBit(Squares.b1)));

    expect(maskPawnAttacks(Squares.h2, side: Side.black),
        equals(BitBoard(0).setBit(Squares.g1)));

    expect(maskPawnAttacks(Squares.b2, side: Side.black),
        equals(BitBoard(0).setBit(Squares.a1).setBit(Squares.c1)));
  });

  test('Test maskKnightAttacks()', () {
    expect(
        maskKnightAttacks(Squares.e4),
        equals(BitBoard(0)
            .setBit(Squares.d6)
            .setBit(Squares.f6)
            .setBit(Squares.d2)
            .setBit(Squares.f2)
            .setBit(Squares.g3)
            .setBit(Squares.g5)
            .setBit(Squares.c3)
            .setBit(Squares.c5)));

    expect(maskKnightAttacks(Squares.a1),
        equals(BitBoard(0).setBit(Squares.b3).setBit(Squares.c2)));

    expect(maskKnightAttacks(Squares.h1),
        equals(BitBoard(0).setBit(Squares.f2).setBit(Squares.g3)));

    expect(
        maskKnightAttacks(Squares.a4),
        equals(BitBoard(0)
            .setBit(Squares.b6)
            .setBit(Squares.b2)
            .setBit(Squares.c5)
            .setBit(Squares.c3)));
  });

  test('Test maskKingAttacks()', () {
    expect(
        maskKingAttacks(Squares.d4),
        equals(BitBoard(0)
            .setBit(Squares.c5)
            .setBit(Squares.d5)
            .setBit(Squares.e5)
            .setBit(Squares.c4)
            .setBit(Squares.e4)
            .setBit(Squares.c3)
            .setBit(Squares.d3)
            .setBit(Squares.e3)));
    expect(
        maskKingAttacks(Squares.a1),
        equals(BitBoard(0)
            .setBit(Squares.a2)
            .setBit(Squares.b2)
            .setBit(Squares.b1)));

    expect(
        maskKingAttacks(Squares.h8),
        equals(BitBoard(0)
            .setBit(Squares.g8)
            .setBit(Squares.g7)
            .setBit(Squares.h7)));

    expect(
        maskKingAttacks(Squares.d1),
        equals(BitBoard(0)
            .setBit(Squares.c1)
            .setBit(Squares.e1)
            .setBit(Squares.c2)
            .setBit(Squares.d2)
            .setBit(Squares.e2)));
  });
}
