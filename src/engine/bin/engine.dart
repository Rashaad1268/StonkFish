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

  // var mask = maskBishopAttacks(0);
  // mask.printBoard(showBoardValue: true);
  // mask = mask * 18018832060792964;
  // mask.printBoard(showBoardValue: true);
  // print(bishopRelevantBits[0]);

  // mask.printBoard();

  // print(
  //     "oijcoisjdcoisjdcoisj oijdsocijosidjcoisdj ${1 << countBits(mask.value)}");
  // for (var i = 0; i < (1 << countBits(mask.value)); i++) {
  // var occupancy = setOccupancy(i, countBits(mask.value), mask);
  // occupancy.printBoard(showBoardValue: true);
  // bishopMasks[i].printBoard();
  // stdin.readLineSync();
  // }

  // bishopMasks[51].printBoard();
  // print("EEEEE ${countBits(bishopMasks[51].value)}");
  // print(bishopAttacks[0].length);
  // print(rookAttacks[0].length);
  // occ.printBoard();
  // print(bishopAttacks[Squares.d4].length);
  // print(bishopAttacks[Squares.d4]);

  // for (final x in bishopAttacks[Squares.d4].values) {
  //   if (x.value == occ.value) print("yesss");
  // }
  // occ.printBoard(showBoardValue: true);
  // bishopAttacks[Squares.d4][occ.value]!.printBoard();
  // print(bishopAttacks[Squares.d4].length);
  // print(bishopMasks.length);
  // getBishopAttacks(Squares.d4, occ).printBoard();
  // final sq = Squares.a1;
  // print(findMagicNumber(sq, rookRelevantBits[sq], false));

  // var bishopMagics = [];
  // var rookMagics = [];
  // for (var square = 0; square < 64; square++) {
  //   bishopMagics.add(findMagicNumber(square, bishopRelevantBits[square], true));
  //   rookMagics.add(findMagicNumber(square, rookRelevantBits[square], false));
  // }
  // print(findMagicNumber(0, bishopRelevantBits[0], true));

  // print("bishopMagicNumbers = $bishopMagics;");
  // print("");
  // print("rookMagicNumbers = $rookMagics;");

  // print(maskBis);
  // print(bishopAttacks[Squares.d4]);
  // print(bishopAttacks[Squares.d4].length);
  // print(occ.printBoard(showBoardValue: true));

  // BitBoard(295).printBoard();
  // print(rookAttacks[Squares.d4][295]!.printBoard());
  occ.printBoard(showBoardValue: true);
  print("dis");
  // getBishopAttacks(Squares.d4, occ).printBoard();
  getBishopAttacks(Squares.d4, occ).printBoard();
  // occ.printBoard(showBoardValue: true);
  // var val = occ.value;
  // val &= bishopMasks[Squares.d4].value;
  // val *= bishopMagicNumbers[Squares.d4];
  // val >>= 64 - bishopRelevantBits[Squares.d4];
  // BitBoard(val).printBoard(showBoardValue: true);

  // rookAttacks[Squares.d4][occ.value];
  print("moment of truth");
  print(bishopAttacks[27][-217]! == bishopAttacks[28][-217]! &&
      bishopAttacks[28][-217]! == bishopAttacks[35][-217]!);
  genBishopAttacksOnTheFly(35, occ.value).printBoard();
  (bishopAttacks[Squares.a8].length);
}
