import 'package:test/test.dart';
import 'package:engine/engine.dart';

void main() {
  initAttacks();

  test('Test legal move generation (start position)', () {
    final board = Board.startingPosition;

    expect(perft(maxDepth: 1, depth: 1, board: board), equals(20));
    expect(perft(maxDepth: 2, depth: 2, board: board), equals(400));
    expect(perft(maxDepth: 3, depth: 3, board: board), equals(8902));
    expect(perft(maxDepth: 4, depth: 4, board: board), equals(197281));
    expect(perft(maxDepth: 5, depth: 5, board: board), equals(4865609));
  });

  test('Test legal move generation (Position 5)', () {
    final board = Board.fromFen(
        'rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8');

    expect(perft(maxDepth: 1, depth: 1, board: board), equals(44));
    expect(perft(maxDepth: 2, depth: 2, board: board), equals(1486));
    expect(perft(maxDepth: 3, depth: 3, board: board), equals(62379));
    // expect(perft(maxDepth: 4, depth: 4, board: board), equals(2103487));
  });
}
