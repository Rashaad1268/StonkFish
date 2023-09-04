import 'package:test/test.dart';
import 'package:engine/utils.dart';
import 'package:engine/constants.dart';

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
}
