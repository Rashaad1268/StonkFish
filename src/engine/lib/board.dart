import 'dart:collection';
import 'dart:io' show stdout;

import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';

class Board {
  late final HashMap<PieceType, BitBoard> pieceBitBoards;

  Board(
      {whiteKing,
      whiteQueens,
      whiteRooks,
      whiteBishops,
      whiteKnights,
      whitePawns,
      blackKing,
      blackQueens,
      blackRooks,
      blackBishops,
      blackKnights,
      blackPawns}) {
    pieceBitBoards = HashMap();
    pieceBitBoards[PieceType.wKing] = whiteKing;
    pieceBitBoards[PieceType.wQueen] = whiteQueens;
    pieceBitBoards[PieceType.wRook] = whiteRooks;
    pieceBitBoards[PieceType.wBishop] = whiteBishops;
    pieceBitBoards[PieceType.wKnight] = whiteKnights;
    pieceBitBoards[PieceType.wPawn] = whitePawns;

    pieceBitBoards[PieceType.bKing] = blackKing;
    pieceBitBoards[PieceType.bQueen] = blackQueens;
    pieceBitBoards[PieceType.bRook] = blackRooks;
    pieceBitBoards[PieceType.bBishop] = blackBishops;
    pieceBitBoards[PieceType.bKnight] = blackKnights;
    pieceBitBoards[PieceType.bPawn] = blackPawns;
  }

  static final startingPosition = Board(
      whiteKing: BitBoard(1152921504606846976),
      whiteQueens: BitBoard(576460752303423488),
      whiteRooks: BitBoard(-9151314442816847872),
      whiteBishops: BitBoard(2594073385365405696),
      whiteKnights: BitBoard(4755801206503243776),
      whitePawns: BitBoard(71776119061217280),
      blackKing: BitBoard(16),
      blackQueens: BitBoard(8),
      blackRooks: BitBoard(129),
      blackBishops: BitBoard(36),
      blackKnights: BitBoard(66),
      blackPawns: BitBoard(65280));

  void printBoard(
      {Side side = Side.white,
      bool useUnicodeCharacters = true,
      bool fillEmptySquares = false}) {
    print('');

    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square = rank * 8 + file;

        if (file == 0) {
          stdout.write("${8 - rank}  | ");
        }

        PieceType? piece;

        for (final pieceType in PieceType.values) {
          var bitBoard = pieceBitBoards[pieceType];

          if (bitBoard!.getBit(square) == 1) {
            piece = pieceType;
          }
        }

        if (piece != null) {
          stdout.write(
              '${useUnicodeCharacters ? unicodePieces[piece] : asciiPieces[piece]} ');
        } else {
          stdout.write(useUnicodeCharacters && fillEmptySquares ? '◻ ' : '  ');
        }

        // stdout.write('${getBit(square)} ');
      }
      stdout.write('\n');
    }

    stdout.write('   ------------------');
    stdout.write('\n     a b c d e f g h\n');
  }

  void makeMove() {
    throw UnimplementedError("Implement this bruh");
  }
}
