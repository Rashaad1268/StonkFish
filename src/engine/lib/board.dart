import 'dart:collection';
import 'dart:io' show stdout;

import 'package:engine/bitboard.dart';
import 'package:engine/constants.dart';
import 'package:engine/utils.dart';

class Board {
  Side turn;

  late final HashMap<PieceType, BitBoard> pieceBitBoards;

  Board(
      {this.turn = Side.white,
      required whiteKing,
      required whiteQueens,
      required whiteRooks,
      required whiteBishops,
      required whiteKnights,
      required whitePawns,
      required blackKing,
      required blackQueens,
      required blackRooks,
      required blackBishops,
      required blackKnights,
      required blackPawns}) {
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
      whiteKing: BitBoard(1152921504606846976, pieceType: PieceType.wKing),
      whiteQueens: BitBoard(576460752303423488, pieceType: PieceType.wQueen),
      whiteRooks: BitBoard(-9151314442816847872, pieceType: PieceType.wRook),
      whiteBishops: BitBoard(2594073385365405696, pieceType: PieceType.wBishop),
      whiteKnights: BitBoard(4755801206503243776, pieceType: PieceType.wKnight),
      whitePawns: BitBoard(71776119061217280, pieceType: PieceType.wPawn),
      blackKing: BitBoard(16, pieceType: PieceType.bKing),
      blackQueens: BitBoard(8, pieceType: PieceType.bQueen),
      blackRooks: BitBoard(129, pieceType: PieceType.bRook),
      blackBishops: BitBoard(36, pieceType: PieceType.bBishop),
      blackKnights: BitBoard(66, pieceType: PieceType.bKnight),
      blackPawns: BitBoard(65280, pieceType: PieceType.bPawn));

  BitBoard get whitePieces =>
      pieceBitBoards[PieceType.wKing]! |
      pieceBitBoards[PieceType.wQueen]! |
      pieceBitBoards[PieceType.wRook]! |
      pieceBitBoards[PieceType.wBishop]! |
      pieceBitBoards[PieceType.wKnight]! |
      pieceBitBoards[PieceType.wPawn]!;

  BitBoard get blackPieces =>
      pieceBitBoards[PieceType.bKing]! |
      pieceBitBoards[PieceType.bQueen]! |
      pieceBitBoards[PieceType.bRook]! |
      pieceBitBoards[PieceType.bBishop]! |
      pieceBitBoards[PieceType.bKnight]! |
      pieceBitBoards[PieceType.bPawn]!;

  String formatBoard(
      {Side? side,
      bool useUnicodeCharacters = true,
      bool fillEmptySquares = false}) {
    final isWhite = (side == Side.white) || turn == Side.white;

    var buffer = "\n";

    if (!useUnicodeCharacters) {
      buffer += "      Turn: ${turn == Side.white ? 'white' : 'black'}\n";
    }

    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square = isWhite ? rank * 8 + file : 63 - (rank * 8 + file);

        if (file == 0) {
          buffer += "${isWhite ? 8 - rank : rank + 1}  | ";
        }

        PieceType? piece = getPieceInSquare(square);

        if (piece != null) {
          buffer +=
              '${useUnicodeCharacters ? unicodePieces[piece] : asciiPieces[piece]} ';
        } else {
          buffer += fillEmptySquares ? '◻ ' : '  ';
        }
      }
      buffer += '\n';
    }

    buffer += '   ------------------';
    buffer += isWhite ? '\n     a b c d e f g h\n' : '\n     h g f e d c b a\n';

    return buffer;
  }

  void printBoard(
          {Side? side,
          bool useUnicodeCharacters = true,
          bool fillEmptySquares = false}) =>
      formatBoard(
          side: side,
          useUnicodeCharacters: useUnicodeCharacters,
          fillEmptySquares: fillEmptySquares);

  PieceType? getPieceInSquare(int square) {
    /* Returns the piece occupying the given square
      if the square is empty returns null */
    for (final entry in pieceBitBoards.entries) {
      final pieceType = entry.key;
      final bitboard = entry.value;

      if (bitboard.getBit(square) == 1) {
        return pieceType;
      }
    }
    return null;
  }

  void makeMove(String move) {
    final from = squareFromAlgebraic(move.substring(0, 2));
    final to = squareFromAlgebraic(move.substring(2, 4));

    if (from == null || to == null) {
      throw ArgumentError('Invalid move supplied');
    }

    final pieceBeingMoved = getPieceInSquare(from);

    if (pieceBeingMoved == null) {
      throw ArgumentError('Invalid move supplied');
    }

    // pieceBeingMoved.idx is the id assigned to the piece, 0-5 is white pieces and 6-11 are black pieces
    if (turn != pieceBeingMoved.color) {
      throw ArgumentError("You can't move the pieces of the other side");
    } else if (turn == Side.black && pieceBeingMoved.idx < 6) {
      throw ArgumentError("You can't move the pieces of the other side");
    }

    var bitBoard = pieceBitBoards[pieceBeingMoved]!;
    bitBoard = bitBoard.popBit(from);
    bitBoard = bitBoard.setBit(to);
    pieceBitBoards[pieceBeingMoved] = bitBoard;

    turn = turn.opposite();
  }

  String toFen() {
    /* Converts the current position into FEN */

    var fen = '';
    var count = 0;

    for (var rank = 0; rank < 8; rank++) {
      for (var file = 0; file < 8; file++) {
        final square = rank * 8 + file;

        final piece = getPieceInSquare(square);

        if (piece == null) {
          count++;
          continue;
        } else {
          fen += "${count > 0 ? count : ''}${asciiPieces[piece]!}";
          count = 0;
        }
      }

      if (rank < 7) {
        fen += "${count > 0 ? count : ''}/";
        count = 0;
      }
    }

    return fen;
  }
}
