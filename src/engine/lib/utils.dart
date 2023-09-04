import 'package:engine/constants.dart';

int getSquareRank(int square) => (square >> 3);

int getSquareFile(int square) => square & 0x7;

String squareToAlgebraic(int square) {
  assert(square >= 0 && square < 64);
  return kFileNames[getSquareFile(square)] + kRankNames[getSquareRank(square)];
}

int? squareFromAlgebraic(String str) {
  if (str.length > 2) return null;

  final file = kFileNames.indexOf(str[0]);
  final rank = int.tryParse(str[1]);

  if (rank == null) return null;

  final square = (8 - rank) * 8 + file;

  if (square > 63) {
    return null;
  }

  return square;
}
