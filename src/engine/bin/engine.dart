import 'package:engine/engine.dart';

import 'interactive_cli.dart';

void main(List<String> arguments) {
  initAttacks();

  // board.printBoard();
  // final board = Board.startingPosition;
  // final engine = Engine(board);

  // const depth = 2;

  // engine.searchPosition(depth);
  // while (board.generateLegalMoves().isNotEmpty) {

  //   if (engine.bestMove != null) {
  //     // print(count);
  //     board.makeMove(engine.bestMove!);
  //   }
  // }

  // board.printBoard();
  // print(board.toFen());
  // print((board.movesPlayed.length / 2).ceil());

  // final board = Board.fromFen(
  //     'rnbqkbnr/1ppppppp/8/7Q/p1B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 4');
  // final engine = Engine(board);

  // engine.searchPosition(2);
  // if (engine.bestMove != null) {
  //   board.makeMove(engine.bestMove!);
  //   board.printBoard(side: Side.white);
  // }
  // final board =
  //     Board.fromFen('6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K1 w - - 0 1');
  // final engine = Engine(board);

  // while (board.generateLegalMoves().isNotEmpty) {
  //   engine.searchPosition(4);

  //   if (engine.bestMove != null) {
  //     board.makeMove(engine.bestMove!);
  //   }
  // }

  // board.printBoard();
  // print(board.toFen());

  // print(Board.fromFen(
  //             'rnbqkbnr/ppp2ppp/8/3pp3/3PP3/8/PPP2PPP/RNBQKBNR w KQkq - 0 3')
  //         .toFen() ==
  //     'rnbqkbnr/ppp2ppp/8/3pp3/3PP3/8/PPP2PPP/RNBQKBNR w KQkq - 0 3');
  // print(Board.fromFen('rnbqkbnr/ppp2ppp/8/3pp3/3PP3/8/PPP2PPP/RNBQKBNR w KQkq - 0 3').toFen());
  final board =
      Board.fromFen('6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K w - - 0 1');

  board.printBoard();
  print(board.toFen());
  print(Board.fromFen('6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K w - - 0 1')
          .toFen() ==
      '6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K w - - 0 1');
  print(Board.fromFen('6k1/2br1p1p/6p1/2B4B/p1b5/2N5/r4PPP/4R1K w - - 0 1')
      .toFen());
}
