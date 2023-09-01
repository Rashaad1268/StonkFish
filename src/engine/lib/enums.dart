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

Map<PieceType, String> asciiPieces = {
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
};

Map<PieceType, String> unicodePieces = {
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
};
