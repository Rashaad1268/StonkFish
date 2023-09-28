import 'package:engine/engine.dart';

int getSquareRank(int square) => (square >> 3);

int getSquareFile(int square) => square & 0x7;

String squareToAlgebraic(int square) {
  assert(square >= 0 && square < 64);
  return squareToCoord[square];
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

int countBits(int bitboard) {
  var count = 0;

  while (bitboard != 0) {
    bitboard &= bitboard - 1;
    count++;
  }
  return count;
}

int getLs1bIndex(int bitboard) {
  assert(bitboard != 0);
  return countBits((bitboard & -bitboard) - 1);
}

BitBoard setOccupancy(int index, int bitsInMask, BitBoard attackMask) {
  var occupancy = BitBoard(0);

  // loop over the range of bits within attack mask
  for (int count = 0; count < bitsInMask; count++) {
    // get LS1B index of attacks mask
    int square = getLs1bIndex(attackMask.value);

    // pop LS1B in attack map
    attackMask = attackMask.popBit(square);

    // make sure occupancy is on board
    if ((index & (1 << count)) > 0) {
      // populate occupancy map
      occupancy |= BitBoard(1 << square);
    }
  }

  return occupancy;
}

String castlingRightsToStr(int rights) {
  var buffer = "";
  if ((rights & CastlingRights.wKingSide) > 0) {
    buffer += "K";
  }
  if ((rights & CastlingRights.wQueenSide) > 0) {
    buffer += "Q";
  }
  if ((rights & CastlingRights.bKingSide) > 0) {
    buffer += "k";
  }
  if ((rights & CastlingRights.bQueenSide) > 0) {
    buffer += "q";
  }
  if (rights == 0) {
    buffer += "-";
  }

  return buffer;
}

int castlingRightsFromStr(String rightsStr) {
  int rights = 0;

  if (rightsStr == "-") return 0;

  if (rightsStr.contains("K")) {
    rights |= CastlingRights.wKingSide;
  }
  if (rightsStr.contains("Q")) {
    rights |= CastlingRights.wQueenSide;
  }
  if (rightsStr.contains("k")) {
    rights |= CastlingRights.bKingSide;
  }
  if (rightsStr.contains("q")) {
    rights |= CastlingRights.bQueenSide;
  }

  return rights;
}
