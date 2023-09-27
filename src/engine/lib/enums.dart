import 'dart:collection';

import 'package:engine/constants.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum PieceType {
  wPawn(0),
  wKnight(1),
  wBishop(2),
  wRook(3),
  wQueen(4),
  wKing(5),

  bPawn(6),
  bKnight(7),
  bBishop(8),
  bRook(9),
  bQueen(10),
  bKing(11);

  static const whitePieces = [wPawn, wKnight, wBishop, wRook, wQueen, wKing];
  static const blackPieces = [bPawn, bKnight, bBishop, bRook, bQueen, bKing];

  final int idx;

  const PieceType(this.idx);

  Side get side {
    if (idx >= 0 && idx < 6) {
      return Side.white;
    } else {
      return Side.black;
    }
  }

  bool get isKing => this == wKing || this == bKing;
  bool get isQueen => this == wQueen || this == bQueen;
  bool get isRook => this == wRook || this == bRook;
  bool get isBishop => this == wBishop || this == bBishop;
  bool get isKnight => this == wKnight || this == bKnight;
  bool get isPawn => this == wPawn || this == bPawn;
}

abstract class CastlingRights {
  static const wKingSide = 1;
  static const wQueenSide = 2;
  static const bKingSide = 4;
  static const bQueenSide = 8;
}

const IMapConst<PieceType, String> asciiPieces = IMapConst({
  PieceType.wKing: "K",
  PieceType.wQueen: "Q",
  PieceType.wRook: "R",
  PieceType.wBishop: "B",
  PieceType.wKnight: "N",
  PieceType.wPawn: "P",
  PieceType.bKing: "k",
  PieceType.bQueen: "q",
  PieceType.bRook: "r",
  PieceType.bBishop: "b",
  PieceType.bKnight: "n",
  PieceType.bPawn: "p",
});

const IMapConst<PieceType, String> pieceToAscii = IMapConst({
  PieceType.wKing: "K",
  PieceType.wQueen: "Q",
  PieceType.wRook: "R",
  PieceType.wBishop: "B",
  PieceType.wKnight: "N",
  PieceType.wPawn: "P",
  PieceType.bKing: "k",
  PieceType.bQueen: "q",
  PieceType.bRook: "r",
  PieceType.bBishop: "b",
  PieceType.bKnight: "n",
  PieceType.bPawn: "p",
});

const IMapConst<PieceType, String> unicodePieces = IMapConst({
  PieceType.bPawn: "♙",
  PieceType.bKnight: "♘",
  PieceType.bBishop: "♗",
  PieceType.bRook: "♖",
  PieceType.bQueen: "♕",
  PieceType.bKing: "♔",
  PieceType.wPawn: "♟︎",
  PieceType.wKnight: "♞",
  PieceType.wBishop: "♝",
  PieceType.wRook: "♜",
  PieceType.wQueen: "♛",
  PieceType.wKing: "♚"
});

HashMap<String, PieceType> pieceFromString = HashMap.fromIterable(
    asciiPieces.entries,
    key: (e) => e.value,
    value: (e) => e.key);

class Move {
  final int from;
  final int to;
  final PieceType piece;
  final PieceType? promotedPiece;
  final int flags;

  Move(
      {required this.from,
      required this.to,
      required this.piece,
      required this.promotedPiece,
      required this.flags});

  @override
  bool operator ==(Object other) {
    return other is Move && other.from == from && other.to == to;
  }

  @override
  int get hashCode => from.hashCode + to.hashCode;
}

abstract class MoveFlags {
  static const int quiet = 0;
  static const int doublePush = 1;
  static const int kingSideCastle = 2;
  static const int queenSideCastle = 3;
  static const int capture = 8;
  static const int captures = 15;
  static const int enPassant = 10;
  static const int promotions = 7;
  static const int promotionCaptures = 12;

  static const int prKnight = 4;
  static const int prBishop = 5;
  static const int prRook = 6;
  static const int pcBishop = 13;
  static const int pcRook = 14;
}
