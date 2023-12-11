import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  initAttacks();

  test('Test UCIParser.parseMove()', () {
    final board = Board.fromFen('8/1PP2qk1/8/8/8/3KQ3/6pp/8 w - - 0 1');

    var move = UCIParser.parseMove(board, 'e3d4');
    expect(
        move,
        equals(Move(
            flags: 0,
            from: Squares.e3,
            to: Squares.d4,
            piece: PieceType.wQueen)));
    board.makeMove(move!);

    move = UCIParser.parseMove(board, 'g7g6');
    expect(
        move,
        equals(Move(
            flags: 0,
            from: Squares.g7,
            to: Squares.g6,
            piece: PieceType.bKing)));
    board.makeMove(move!);

    move = UCIParser.parseMove(board, 'c7c8q');
    expect(
        move,
        equals(Move(
            flags: 0,
            from: Squares.c7,
            to: Squares.c8,
            promotedPiece: PieceType.wQueen,
            piece: PieceType.wPawn)));
    board.makeMove(move!);

    move = UCIParser.parseMove(board, 'c7c8k');
    expect(move, equals(null));
  });

  // test('Test UCIParser.parsePosition()', () {
  //   UCIParser.parsePosition('');
  // });
}
