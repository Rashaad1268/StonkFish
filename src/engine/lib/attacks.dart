import 'dart:collection';

import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';
import 'package:engine/utils.dart';

final HashMap<Side, List<BitBoard>> pawnAttacks =
    HashMap.from({Side.white: <BitBoard>[], Side.black: <BitBoard>[]});

final List<BitBoard> kingAttacks = [];

List<BitBoard> knightAttacks = [];
List<BitBoard> bishopMasks = [];
List<BitBoard> rookMasks = [];
List<BitBoard> bishopAttacks = [];
List<BitBoard> rookAttacks = [];

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

void init() {
  for (var square = 0; square < 64; square++) {
    final rank = getSquareRank(square);

    // No need to mask attacks for the 1st and 8th ranks
    if (rank != 0 && rank != 7) {
      pawnAttacks[Side.white]!.add(maskPawnAttacks(square, side: Side.white));
      pawnAttacks[Side.black]!.add(maskPawnAttacks(square, side: Side.black));
    }

    knightAttacks[square] = maskKnightAttacks(square);

    kingAttacks[square] = maskKingAttacks(square);
  }
}
