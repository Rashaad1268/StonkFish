import 'package:engine/engine.dart';

import 'interactive_cli.dart';

void main(List<String> arguments) {
  initAttacks();

  // var board = Board.fromFen(
  //     'rnbqkbnr/1ppp1ppp/8/p3p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 4');

  // // board.printBoard();
  // print(board.evaluate());
  // board.searchPosition(2);
  final board = Board.startingPosition;
  interactiveCliMatch(board);

  board.searchPosition(3);
}
