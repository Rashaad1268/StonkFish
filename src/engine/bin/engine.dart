import 'dart:io';

import 'package:engine/engine.dart';

void main(List<String> arguments) {
  init();

  var occ = BitBoard(0);

  occ = occ.setBit(Squares.c5);
  occ = occ.setBit(Squares.f2);
  occ = occ.setBit(Squares.g7);
  occ = occ.setBit(Squares.b2);
  occ = occ.setBit(Squares.g5);
  occ = occ.setBit(Squares.e2);
  occ = occ.setBit(Squares.e7);

  occ.printBoard(showBoardValue: true);
  getBishopAttacks(Squares.d4, occ).printBoard();
  getRookAttacks(Squares.g2, occ).printBoard();
}
