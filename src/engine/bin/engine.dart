import 'package:engine/engine.dart';


void main(List<String> arguments) {
  initAttacks();

  var board = Board.fromFen(
      'r4rk1/1pp1qppp/p1np1n2/2b1p1B1/2B1P1b1/P1NP1N2/1PP1QPPP/R4RK1 w - - 0 10');

  print(perft(maxDepth: 5, depth: 5, board: board));

}
