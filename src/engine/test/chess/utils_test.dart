import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  test('Test getSquareRank()', () {
    expect(getSquareRank(Squares.a1), equals(7));
    expect(getSquareRank(Squares.b2), equals(6));
    expect(getSquareRank(Squares.c3), equals(5));
    expect(getSquareRank(Squares.d4), equals(4));
    expect(getSquareRank(Squares.e5), equals(3));
    expect(getSquareRank(Squares.f6), equals(2));
    expect(getSquareRank(Squares.g7), equals(1));
    expect(getSquareRank(Squares.h8), equals(0));
  });

  test('Test getSquareFile()', () {
    expect(getSquareFile(Squares.a1), equals(0));
    expect(getSquareFile(Squares.a2), equals(0));

    expect(getSquareFile(Squares.b1), equals(1));
    expect(getSquareFile(Squares.b2), equals(1));

    expect(getSquareFile(Squares.c2), equals(2));
    expect(getSquareFile(Squares.c3), equals(2));

    expect(getSquareFile(Squares.d4), equals(3));
    expect(getSquareFile(Squares.d5), equals(3));

    expect(getSquareFile(Squares.e4), equals(4));
    expect(getSquareFile(Squares.e5), equals(4));

    expect(getSquareFile(Squares.f5), equals(5));
    expect(getSquareFile(Squares.f6), equals(5));

    expect(getSquareFile(Squares.g7), equals(6));
    expect(getSquareFile(Squares.g8), equals(6));

    expect(getSquareFile(Squares.h7), equals(7));
    expect(getSquareFile(Squares.h8), equals(7));
  });

  test('Test squareFromAlgebraic()', () {
    expect(squareFromAlgebraic('a1'), equals(Squares.a1));
    expect(squareFromAlgebraic('b2'), equals(Squares.b2));
    expect(squareFromAlgebraic('c3'), equals(Squares.c3));
    expect(squareFromAlgebraic('d4'), equals(Squares.d4));
    expect(squareFromAlgebraic('e5'), equals(Squares.e5));
    expect(squareFromAlgebraic('f6'), equals(Squares.f6));
    expect(squareFromAlgebraic('g7'), equals(Squares.g7));
    expect(squareFromAlgebraic('h8'), equals(Squares.h8));
  });

  test('Test squareToAlgebraic()', () {
    expect(squareToAlgebraic(Squares.a1), equals('a1'));
    expect(squareToAlgebraic(Squares.b2), equals('b2'));
    expect(squareToAlgebraic(Squares.c3), equals('c3'));
    expect(squareToAlgebraic(Squares.d4), equals('d4'));
    expect(squareToAlgebraic(Squares.e5), equals('e5'));
    expect(squareToAlgebraic(Squares.f6), equals('f6'));
    expect(squareToAlgebraic(Squares.g7), equals('g7'));
    expect(squareToAlgebraic(Squares.h8), equals('h8'));
  });

  test('Test countBits()', () {
    final board = Board.startingPosition;

    expect(countBits(board.whitePieces.value), equals(16));
    expect(countBits(board.blackPieces.value), equals(16));
    expect(
        countBits((board.whitePieces | board.blackPieces).value), equals(32));
  });

  test('Test getLs1bIndex()', () {
    final board = Board.startingPosition;

    expect(() => getLs1bIndex(0), throwsA(isA<AssertionError>()));
    expect(getLs1bIndex(board.whitePieces.value), equals(Squares.a2));
    expect(getLs1bIndex(board.blackPieces.value), equals(Squares.a8));
  });

  test('Test castlingRightsToStr', () {
    expect(castlingRightsToStr(0), equals("-"));
    expect(castlingRightsToStr(5), equals("Kk"));
    expect(castlingRightsToStr(7), equals("KQk"));
    expect(castlingRightsToStr(13), equals("Kkq"));
    expect(castlingRightsToStr(15), equals("KQkq"));
  });

  test('Test castlingRightsFromStr', () {
    expect(castlingRightsFromStr("-"), equals(0));
    expect(castlingRightsFromStr("Kk"), equals(5));
    expect(castlingRightsFromStr("KQk"), equals(7));
    expect(castlingRightsFromStr("Kkq"), equals(13));
    expect(castlingRightsFromStr("KQkq"), equals(15));
  });
}
