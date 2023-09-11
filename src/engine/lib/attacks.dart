import 'dart:collection';

import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';
import 'package:engine/magic_numbers.dart';
import 'package:engine/utils.dart';

final HashMap<Side, List<BitBoard>> pawnAttacks = HashMap.from({
  Side.white: List.filled(64, BitBoard(0)),
  Side.black: List.filled(64, BitBoard(0))
});

List<BitBoard> kingAttacks = List.filled(64, BitBoard(0));
List<BitBoard> knightAttacks = List.filled(64, BitBoard(0));
List<BitBoard> bishopMasks = List.filled(64, BitBoard(0));
List<BitBoard> rookMasks = List.filled(64, BitBoard(0));

List<Map<int, BitBoard>> bishopAttacks = List.filled(64, {});
List<Map<int, BitBoard>> rookAttacks = List.filled(64, {});

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

void initSlidersAttacks(bool isBishop) {
  // loop over 64 board squares
  for (int square = 0; square < 64; square++) {
    // init bishop & rook masks
    bishopMasks[square] = maskBishopAttacks(square);
    rookMasks[square] = maskRookAttacks(square);

    // init current mask
    int attack_mask =
        (isBishop ? bishopMasks[square] : rookMasks[square]).value;

    // init relevant occupancy bit count
    int relevant_bits_count = countBits(attack_mask);

    // init occupancy indicies
    int occupancy_indicies = (1 << relevant_bits_count);

    // loop over occupancy indicies
    for (int index = 0; index < occupancy_indicies; index++) {
      // bishop
      if (isBishop) {
        // init current occupancy variation
        int occupancy =
            setOccupancy(index, relevant_bits_count, BitBoard(attack_mask))
                .value;

        // init magic index
        int magic_index = (occupancy * bishopMagicNumbers[square]) >>
            (64 - bishopRelevantBits[square]);

        // init bishop attacks
        if (bishopAttacks[square][magic_index]?.value !=
            genBishopAttacksOnTheFly(square, occupancy).value) {
          bishopAttacks[square][magic_index] =
              genBishopAttacksOnTheFly(square, occupancy);
        }
      }

      // rook
      else {
        // init current occupancy variation
        int occupancy =
            setOccupancy(index, relevant_bits_count, BitBoard(attack_mask))
                .value;

        // init magic index
        int magic_index = (occupancy * rookMagicNumbers[square]) >>
            (64 - rookRelevantBits[square]);

        // init rook attacks
        rookAttacks[square][magic_index] =
            genRookAttacksOnTheFly(square, occupancy);
      }
    }
  }
}

BitBoard getBishopAttacks(int square, BitBoard occupancy) {
  // get bishop attacks assuming current board occupancy
  var value = occupancy.value & bishopMasks[square].value;

  return bishopAttacks[square][(value * bishopMagicNumbers[square]) >>
      (64 - bishopRelevantBits[square])]!;
}

void init() {
  for (var square = 0; square < 64; square++) {
    final rank = getSquareRank(square);

    // No need to mask attacks for the 1st and 8th ranks
    if (rank != 0 && rank != 7) {
      pawnAttacks[Side.white]![square] =
          maskPawnAttacks(square, side: Side.white);
      pawnAttacks[Side.black]![square] =
          maskPawnAttacks(square, side: Side.black);
    }

    knightAttacks[square] = maskKnightAttacks(square);

    kingAttacks[square] = maskKingAttacks(square);
  }

  initSlidersAttacks(true);
  initSlidersAttacks(false);
}
