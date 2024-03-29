import 'dart:collection';

import 'package:engine/engine.dart';
export 'package:engine/chess/move_gen.dart';
export 'package:engine/chess/board_copy.dart';
export 'package:engine/chess/move_maker.dart';

class Board {
  Side turn;
  int castlingRights;
  int? enPassant;
  int halfMoveClock;
  int movesPlayed = 1;

  HashMap<PieceType, BitBoard> pieceBitBoards = HashMap();

  Board(
      {required this.turn,
      required this.enPassant,
      required this.castlingRights,
      required this.halfMoveClock,
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

  static Board startingPosition() => Board(
      castlingRights: CastlingRights.wKingSide |
          CastlingRights.wQueenSide |
          CastlingRights.bKingSide |
          CastlingRights.bQueenSide,
      halfMoveClock: 0,
      turn: Side.white,
      enPassant: null,
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

  static Board empty() => Board(
      castlingRights: 0,
      halfMoveClock: 0,
      turn: Side.white,
      enPassant: null,
      whiteKing: BitBoard(0, pieceType: PieceType.wKing),
      whiteQueens: BitBoard(0, pieceType: PieceType.wQueen),
      whiteRooks: BitBoard(0, pieceType: PieceType.wRook),
      whiteBishops: BitBoard(0, pieceType: PieceType.wBishop),
      whiteKnights: BitBoard(0, pieceType: PieceType.wKnight),
      whitePawns: BitBoard(0, pieceType: PieceType.wPawn),
      blackKing: BitBoard(0, pieceType: PieceType.bKing),
      blackQueens: BitBoard(0, pieceType: PieceType.bQueen),
      blackRooks: BitBoard(0, pieceType: PieceType.bRook),
      blackBishops: BitBoard(0, pieceType: PieceType.bBishop),
      blackKnights: BitBoard(0, pieceType: PieceType.bKnight),
      blackPawns: BitBoard(0, pieceType: PieceType.bPawn));

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

  BitBoard get allPieces => whitePieces | blackPieces;

  bool get isCheck => isSquareAttacked(
      getLs1bIndex(turn.isWhite
          ? pieceBitBoards[PieceType.wKing]!.value
          : pieceBitBoards[PieceType.bKing]!.value),
      turn.opposite());

  BitBoard piecesOf(Side side) {
    return side == Side.white ? whitePieces : blackPieces;
  }

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
          buffer += fillEmptySquares ? '. ' : '  ';
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
          bool fillEmptySquares = true}) =>
      print(formatBoard(
          side: side,
          useUnicodeCharacters: useUnicodeCharacters,
          fillEmptySquares: fillEmptySquares));

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

    fen += turn == Side.white ? " w" : " b";

    fen += " ${castlingRightsToStr(castlingRights)} ";

    if (enPassant != null) {
      fen += squareToAlgebraic(enPassant!);
    } else {
      fen += "- ";
    }

    fen += "$halfMoveClock ";
    fen += "$movesPlayed";

    return fen;
  }

  static Board fromFen(String fen) {
    var board = Board.empty();
    int square = 0;

    // ignore: no_leading_underscores_for_local_identifiers
    final _fen = fen.split(" ");
    final pieceFen = _fen[0];
    final moveTurn = _fen[1];
    final castlingRights = _fen[2];
    final enPassant = _fen[3];
    final halfMoveClock = int.tryParse(_fen.elementAtOrNull(4) ?? '0');
    final fullMoveNumber = int.tryParse(_fen.elementAtOrNull(5) ?? '0');

    for (String char in pieceFen.split('')) {
      if (int.tryParse(char) != null) {
        square += int.parse(char);
        continue;
      } else if (char == "/") {
        continue;
      } else {
        final piece = pieceFromString[char]!;

        board.pieceBitBoards[piece] =
            board.pieceBitBoards[piece]!.setBit(square);
        square++;
      }
    }

    if (moveTurn == "w") {
      board.turn = Side.white;
    } else {
      board.turn = Side.black;
    }

    board.castlingRights = castlingRightsFromStr(castlingRights);

    if (enPassant != "-") {
      board.enPassant = squareFromAlgebraic(enPassant)!;
    }

    board.halfMoveClock = halfMoveClock ?? 0;

    board.movesPlayed = fullMoveNumber ?? 1;

    return board;
  }
}
