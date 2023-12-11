import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  initAttacks();

  test('Test legal move generation (start position)', () {
    final board = Board.startingPosition();

    expect(perft(depth: 1, board: board), equals(20));
    expect(perft(depth: 2, board: board), equals(400));
    expect(perft(depth: 3, board: board), equals(8902));
    expect(perft(depth: 4, board: board), equals(197281));
  });

  test('Test legal move generation (Position 5)', () {
    final board = Board.fromFen(
        'rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8');

    expect(perft(depth: 1, board: board), equals(44));
    expect(perft(depth: 2, board: board), equals(1486));
    expect(perft(depth: 3, board: board), equals(62379));
    expect(perft(depth: 4, board: board), equals(2103487));
  });
}
