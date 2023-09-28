import 'dart:collection';

import 'package:engine/engine.dart';

final List<List<BitBoard>> pawnAttacks = [
  List.generate(64, (_) => BitBoard(0)), // White pawns
  List.generate(64, (_) => BitBoard(0)) // Black pawns
];
/* Only use List.filled with mutable objects,
   BitBoard is not mutable but we don't use List.filled to hopefully avoid any bugs in the future
*/
List<BitBoard> kingAttacks = List.generate(64, (_) => BitBoard(0));
List<BitBoard> knightAttacks = List.generate(64, (_) => BitBoard(0));
List<BitBoard> bishopMasks = List.generate(64, (_) => BitBoard(0));
List<BitBoard> rookMasks = List.generate(64, (_) => BitBoard(0));

/* Use List.generate especially for mutable objects such as Maps
   because the same instance is shared by every element of the list */
List<HashMap<int, BitBoard>> bishopAttacks =
    List.generate(64, (_) => HashMap());
List<HashMap<int, BitBoard>> rookAttacks = List.generate(64, (_) => HashMap());

BitBoard maskPawnAttacks(int square, {required Side side}) {
  final bitboard = BitBoard(0).setBit(square);
  var attacks = BitBoard(0);

  if (side == Side.white) {
    // generate white pawn attacks
    if (((bitboard >> 7) & NOT_A_FILE).value > 0) attacks |= (bitboard >> 7);
    if (((bitboard >> 9) & NOT_H_FILE).value > 0) attacks |= (bitboard >> 9);
  } else {
    // generate black pawn attacks
    if (((bitboard << 7) & NOT_H_FILE).value > 0) attacks |= (bitboard << 7);
    if (((bitboard << 9) & NOT_A_FILE).value > 0) attacks |= (bitboard << 9);
  }

  return attacks;
}

BitBoard maskKnightAttacks(int square) {
  final bitboard = BitBoard(0).setBit(square);
  var attacks = BitBoard(0);

  if (((bitboard >> 17) & NOT_H_FILE).value > 0) attacks |= (bitboard >> 17);
  if (((bitboard >> 15) & NOT_A_FILE).value > 0) attacks |= (bitboard >> 15);
  if (((bitboard >> 10) & NOT_HG_FILE).value > 0) attacks |= (bitboard >> 10);
  if (((bitboard >> 6) & NOT_AB_FILE).value > 0) attacks |= (bitboard >> 6);
  if (((bitboard << 17) & NOT_A_FILE).value > 0) attacks |= (bitboard << 17);
  if (((bitboard << 15) & NOT_H_FILE).value > 0) attacks |= (bitboard << 15);
  if (((bitboard << 10) & NOT_AB_FILE).value > 0) attacks |= (bitboard << 10);
  if (((bitboard << 6) & NOT_HG_FILE).value > 0) attacks |= (bitboard << 6);

  return attacks;
}

BitBoard maskKingAttacks(int square) {
  final bitboard = BitBoard(0).setBit(square);
  var attacks = BitBoard(0);

  if ((bitboard >> 8).value > 0) attacks |= (bitboard >> 8);
  if (((bitboard >> 9) & NOT_H_FILE).value > 0) attacks |= (bitboard >> 9);
  if (((bitboard >> 7) & NOT_A_FILE).value > 0) attacks |= (bitboard >> 7);
  if (((bitboard >> 1) & NOT_H_FILE).value > 0) attacks |= (bitboard >> 1);
  if ((bitboard << 8).value > 0) attacks |= (bitboard << 8);
  if (((bitboard << 9) & NOT_A_FILE).value > 0) attacks |= (bitboard << 9);
  if (((bitboard << 7) & NOT_H_FILE).value > 0) attacks |= (bitboard << 7);
  if (((bitboard << 1) & NOT_A_FILE).value > 0) attacks |= (bitboard << 1);

  return attacks;
}

BitBoard maskBishopAttacks(int square) {
  var attacks = BitBoard(0);

  var tr = (square / 8).floor();
  var tf = square % 8;

  // mask relevant bishop occupancy bits
  // TODO: Maybe combine all of these loops into a single loop? (skill issue)
  for (var r = tr + 1, f = tf + 1; r <= 6 && f <= 6; r++, f++) {
    attacks |= BitBoard(1 << (r * 8 + f));
  }

  for (var r = tr - 1, f = tf + 1; r >= 1 && f <= 6; r--, f++) {
    attacks |= BitBoard(1 << (r * 8 + f));
  }

  for (var r = tr + 1, f = tf - 1; r <= 6 && f >= 1; r++, f--) {
    attacks |= BitBoard(1 << (r * 8 + f));
  }

  for (var r = tr - 1, f = tf - 1; r >= 1 && f >= 1; r--, f--) {
    attacks |= BitBoard(1 << (r * 8 + f));
  }

  // return attack map
  return attacks;
}

BitBoard maskRookAttacks(int square) {
  // result attacks bitboard
  var attacks = BitBoard(0);

  // init target rank & files
  var tr = (square / 8).floor();
  var tf = square % 8;

  // Mask relevant bishop occupancy bits
  // TODO: Maybe combine all of these loops into a single loop? (skill issue)
  for (var r = tr + 1; r <= 6; r++) {
    attacks |= BitBoard(1 << (r * 8 + tf));
  }
  for (var r = tr - 1; r >= 1; r--) {
    attacks |= BitBoard(1 << (r * 8 + tf));
  }
  for (var f = tf + 1; f <= 6; f++) {
    attacks |= BitBoard(1 << (tr * 8 + f));
  }
  for (var f = tf - 1; f >= 1; f--) {
    attacks |= BitBoard(1 << (tr * 8 + f));
  }

  return attacks;
}

BitBoard genBishopAttacksOnTheFly(int square, int blockers) {
  // result attacks bitboard
  var attacks = BitBoard(0);

  // init target rank & files
  var tr = (square / 8).floor();
  var tf = square % 8;

  // generate bishop atacks
  for (var r = tr + 1, f = tf + 1; r <= 7 && f <= 7; r++, f++) {
    attacks |= BitBoard(1 << (r * 8 + f));
    if (((1 << (r * 8 + f)) & blockers) > 0) break;
  }

  for (var r = tr - 1, f = tf + 1; r >= 0 && f <= 7; r--, f++) {
    attacks |= BitBoard(1 << (r * 8 + f));
    if (((1 << (r * 8 + f)) & blockers) > 0) break;
  }

  for (var r = tr + 1, f = tf - 1; r <= 7 && f >= 0; r++, f--) {
    attacks |= BitBoard(1 << (r * 8 + f));
    if (((1 << (r * 8 + f)) & blockers) > 0) break;
  }

  for (var r = tr - 1, f = tf - 1; r >= 0 && f >= 0; r--, f--) {
    attacks |= BitBoard(1 << (r * 8 + f));
    if (((1 << (r * 8 + f)) & blockers) > 0) break;
  }

  // return attack map
  return attacks;
}

BitBoard genRookAttacksOnTheFly(int square, int blockers) {
  var attacks = BitBoard(0);

  // init target rank & files
  var tr = (square / 8).floor();
  var tf = square % 8;

  // generate rook attacks
  for (var r = tr + 1; r <= 7; r++) {
    attacks |= BitBoard(1 << (r * 8 + tf));
    if (((1 << (r * 8 + tf)) & blockers) > 0) break;
  }

  for (var r = tr - 1; r >= 0; r--) {
    attacks |= BitBoard(1 << (r * 8 + tf));
    if (((1 << (r * 8 + tf)) & blockers) > 0) break;
  }

  for (var f = tf + 1; f <= 7; f++) {
    attacks |= BitBoard(1 << (tr * 8 + f));
    if (((1 << (tr * 8 + f)) & blockers) > 0) break;
  }

  for (var f = tf - 1; f >= 0; f--) {
    attacks |= BitBoard(1 << (tr * 8 + f));
    if (((1 << (tr * 8 + f)) & blockers) > 0) break;
  }

  // return attack map
  return attacks;
}

void initSliderAttacks(bool isBishop) {
  // loop over 64 board squares
  for (int square = 0; square < 64; square++) {
    bishopMasks[square] = maskBishopAttacks(square);
    rookMasks[square] = maskRookAttacks(square);

    // Get current attack mask
    final attackMask = isBishop ? bishopMasks[square] : rookMasks[square];

    int relevantBitsCount = countBits(attackMask.value);
    int occupancyIndicies = (1 << relevantBitsCount);

    for (int index = 0; index < occupancyIndicies; index++) {
      if (isBishop) {
        // Bishop
        // Get the current occupancy variation
        final occupancy =
            setOccupancy(index, relevantBitsCount, attackMask).value;

        // Initialize magic index
        int magicIndex = (occupancy * bishopMagicNumbers[square]) >>
            (64 - bishopRelevantBits[square]);

        // Set the bishop attacks
        bishopAttacks[square][magicIndex] =
            genBishopAttacksOnTheFly(square, occupancy);
      } else {
        // Rook
        // Get the current occupancy variation
        final occupancy =
            setOccupancy(index, relevantBitsCount, attackMask).value;

        // Initialize magic index
        int magicIndex = (occupancy * rookMagicNumbers[square]) >>
            (64 - rookRelevantBits[square]);

        // Set the rook attacks
        rookAttacks[square][magicIndex] =
            genRookAttacksOnTheFly(square, occupancy);
      }
    }
  }
}

BitBoard getBishopAttacks(int square, BitBoard occupancy) {
  // get bishop attacks assuming current board occupancy
  var occ = occupancy.value;
  occ &= bishopMasks[square].value;
  occ *= bishopMagicNumbers[square];
  occ >>= 64 - bishopRelevantBits[square];

  return bishopAttacks[square][occ]!;
}

BitBoard getRookAttacks(int square, BitBoard occupancy) {
  // get rook attacks assuming current board occupancy
  var occ = occupancy.value;
  occ &= rookMasks[square].value;
  occ *= rookMagicNumbers[square];
  occ >>= 64 - rookRelevantBits[square];

  return rookAttacks[square][occ]!;
}

BitBoard getQueenAttacks(int square, BitBoard occupancy) {
  return getBishopAttacks(square, occupancy) |
      getRookAttacks(square, occupancy);
}

void initAttacks() {
  for (var square = 0; square < 64; square++) {
    // We also need to mask attacks for the 1th and 8th ranks
    pawnAttacks[0][square] = maskPawnAttacks(square, side: Side.white);
    pawnAttacks[1][square] = maskPawnAttacks(square, side: Side.black);

    knightAttacks[square] = maskKnightAttacks(square);

    kingAttacks[square] = maskKingAttacks(square);
  }

  initSliderAttacks(true);
  initSliderAttacks(false);
}

extension AttackGeneration on Board {
  bool isSquareAttacked(int square, Side side) {
    // attacked by white pawns
    final isWhite = side == Side.white;

    // attacked by white pawns
    if ((side.isWhite) &&
        (pawnAttacks[1][square] & pieceBitBoards[PieceType.wPawn]!).notEmpty())
      return true;

    // attacked by black pawns
    if ((side == Side.black) &&
        (pawnAttacks[0][square] & pieceBitBoards[PieceType.bPawn]!).notEmpty())
      return true;

    // attacked by knights
    if ((knightAttacks[square] &
            ((isWhite)
                ? pieceBitBoards[PieceType.wKnight]!
                : pieceBitBoards[PieceType.bKnight]!))
        .notEmpty()) return true;

    // attacked by bishops
    if ((getBishopAttacks(square, allPieces) &
            ((isWhite)
                ? pieceBitBoards[PieceType.wBishop]!
                : pieceBitBoards[PieceType.bBishop]!))
        .notEmpty()) return true;

    // attacked by rooks
    if ((getRookAttacks(square, allPieces) &
            ((isWhite)
                ? pieceBitBoards[PieceType.wRook]!
                : pieceBitBoards[PieceType.bRook]!))
        .notEmpty()) return true;

    // attacked by bishops
    if ((getQueenAttacks(square, allPieces) &
            ((isWhite)
                ? pieceBitBoards[PieceType.wQueen]!
                : pieceBitBoards[PieceType.bQueen]!))
        .notEmpty()) return true;

    // attacked by kings
    if ((kingAttacks[square] &
            ((isWhite)
                ? pieceBitBoards[PieceType.wKing]!
                : pieceBitBoards[PieceType.bKing]!))
        .notEmpty()) return true;

    // by default return false
    return false;
  }
}
