import 'package:engine/engine.dart';

int _perft(
    {required int maxDepth,
    required int depth,
    required Board board,
    bool printResults = false}) {
  if (depth == 0) {
    return 1;
  }

  int nodes = 0;

  final moves = board.generateLegalMoves();

  if (depth == 1) {
    return moves.length;
  }

  for (final move in moves) {
    final copyOfBoard = board.toCopy();

    board.makeMove(move);

    final result = _perft(
        maxDepth: maxDepth,
        depth: depth - 1,
        board: board,
        printResults: printResults);

    nodes += result;

    if ((depth == maxDepth) && printResults) {
      final promotedPiece = move.promotedPiece != null
          ? asciiPieces[move.promotedPiece!]!.toLowerCase()
          : '';
      print(
          """${squareToAlgebraic(move.from)}${squareToAlgebraic(move.to)}$promotedPiece $result""");
    }

    board.revertTo(copyOfBoard);
  }

  return nodes;
}

int perft(
    {required int depth, required Board board, bool printResults = false}) {
  return _perft(maxDepth: depth, depth: depth, board: board);
}
