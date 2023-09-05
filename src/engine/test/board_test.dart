import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  test('Test Board.toFen()', () {
    final board = Board.startingPosition;

    expect(board.toFen(), equals(kStartingPosFEN));
  });

  test('Test Bord.makeMove()', () {
    final board = Board.startingPosition;

    board.makeMove('d2d4');
    expect(
        board.pieceBitBoards[PieceType.wPawn]!.getBit(Squares.d2), equals(0));
    expect(
        board.pieceBitBoards[PieceType.wPawn]!.getBit(Squares.d4), equals(1));

    board.makeMove('d7d5');
    expect(
        board.pieceBitBoards[PieceType.bPawn]!.getBit(Squares.d2), equals(0));
    expect(
        board.pieceBitBoards[PieceType.bPawn]!.getBit(Squares.d5), equals(1));

    board.makeMove('e1d2');
    expect(
        board.pieceBitBoards[PieceType.wKing]!.getBit(Squares.e1), equals(0));
    expect(
        board.pieceBitBoards[PieceType.wKing]!.getBit(Squares.d2), equals(1));

    board.makeMove('e8d7');
    expect(
        board.pieceBitBoards[PieceType.bKing]!.getBit(Squares.e8), equals(0));
    expect(
        board.pieceBitBoards[PieceType.bKing]!.getBit(Squares.d7), equals(1));

    expect(() => board.makeMove('h5h6'), throwsArgumentError);

    expect(() => board.makeMove('a7a6'), throwsArgumentError);
  });
}
