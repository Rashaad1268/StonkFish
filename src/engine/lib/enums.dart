import 'dart:collection';

import 'package:engine/constants.dart';

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

  final int idx;

  const PieceType(this.idx);

  Side get color {
    if (idx >= 0 && idx < 6) {
      return Side.white;
    } else {
      return Side.black;
    }
  }
}

class MoveFlags {
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

enum CastlingRights {
  wKingSide(1),
  wQueenSide(2),
  bKingSide(4),
  bQueenSide(8);

  final int value;
  const CastlingRights(this.value);

  int xor(CastlingRights other) => value ^ other.value;
  int operator ^(CastlingRights other) => value ^ other.value;

  int union(CastlingRights other) => value | other.value;
  int operator |(CastlingRights other) => value | other.value;

  int intersect(CastlingRights other) => value & other.value;
  int operator &(CastlingRights other) => value & other.value;

  int minus(CastlingRights other) => value - other.value;
  int operator -(CastlingRights other) => value - other.value;

  int complement() => ~value;
}

HashMap<PieceType, String> asciiPieces = HashMap.from({
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

HashMap<PieceType, String> unicodePieces = HashMap.from({
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

HashMap<String, PieceType> stringTopiece = HashMap.fromIterable(
    asciiPieces.entries,
    key: (e) => e.value,
    value: (e) => e.key);

class Move {
  final String from;
  final String to;

  Move({required this.from, required this.to});

  @override
  bool operator ==(Object other) {
    return other is Move && other.from == from && other.to == to;
  }

  @override
  int get hashCode => from.hashCode + to.hashCode;
}
