import 'package:engine/engine.dart';

import 'interactive_cli.dart';

void main(List<String> arguments) {
  initAttacks();

  // board.printBoard();
  final board = Board.startingPosition;
  final engine = Engine(board);

  const depth = 2;

  var count = 0;

  while (board.generateLegalMoves().isNotEmpty) {
    engine.searchPosition(depth);

    if (engine.bestMove != null) {
      count++;
      // print(count);
      board.makeMove(engine.bestMove!);
    }
  }

  board.printBoard();
  print(board.toFen());
  print((board.movesPlayed.length/2).ceil());

  // final board = Board.fromFen(
  //     'rnbqkbnr/1ppppppp/8/7Q/p1B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 4');
  // final engine = Engine(board);

  // engine.searchPosition(2);
  // if (engine.bestMove != null) {
  //   board.makeMove(engine.bestMove!);
  //   board.printBoard(side: Side.white);
  // }
}
