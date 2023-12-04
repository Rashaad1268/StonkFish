import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  test('Test Board.fromFen', () {
    final board = Board.fromFen(
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');

    expect(board.whitePieces, equals(Board.startingPosition.whitePieces));
    expect(board.blackPieces, equals(Board.startingPosition.blackPieces));

    expect(board.halfMoveClock, 0);
    expect(board.fullMoveNumber, 1);
  });

  test('Test Board.toFen()', () {
    final board = Board.startingPosition;

    expect(board.toFen(),
        equals('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'));
  });

  test('Test Bord.makeMove()', () {
    final board = Board.startingPosition;

    board.makeMove(Move(
        from: Squares.d2,
        to: Squares.d4,
        piece: PieceType.wPawn,
        flags: MoveFlags.quiet));
    expect(
        board.pieceBitBoards[PieceType.wPawn]!.getBit(Squares.d2), equals(0));
    expect(
        board.pieceBitBoards[PieceType.wPawn]!.getBit(Squares.d4), equals(1));

    board.makeMove(Move(
        from: Squares.d7,
        to: Squares.d5,
        piece: PieceType.bPawn,
        flags: MoveFlags.quiet));
    expect(
        board.pieceBitBoards[PieceType.bPawn]!.getBit(Squares.d2), equals(0));
    expect(
        board.pieceBitBoards[PieceType.bPawn]!.getBit(Squares.d5), equals(1));

    board.makeMove(Move(
        from: Squares.e1,
        to: Squares.d2,
        piece: PieceType.wKing,
        flags: MoveFlags.quiet));
    expect(
        board.pieceBitBoards[PieceType.wKing]!.getBit(Squares.e1), equals(0));
    expect(
        board.pieceBitBoards[PieceType.wKing]!.getBit(Squares.d2), equals(1));

    board.makeMove(Move(
        from: Squares.e8,
        to: Squares.d7,
        piece: PieceType.bKing,
        flags: MoveFlags.quiet));
    expect(
        board.pieceBitBoards[PieceType.bKing]!.getBit(Squares.e8), equals(0));
    expect(
        board.pieceBitBoards[PieceType.bKing]!.getBit(Squares.d7), equals(1));

    expect(
        () => board.makeMove(Move(
            from: Squares.h7,
            to: Squares.h6,
            piece: PieceType.bPawn,
            flags: 0)),
        throwsArgumentError);
  });
}
