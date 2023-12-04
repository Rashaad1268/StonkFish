import 'package:engine/engine.dart';

final materialScore = {
  PieceType.wPawn: 100, // white pawn score
  PieceType.wKnight: 300, // white knight scrore
  PieceType.wBishop: 350, // white bishop score
  PieceType.wRook: 500, // white rook score
  PieceType.wQueen: 1000, // white queen score
  PieceType.wKing: 10000, // white king score
  PieceType.bPawn: -100, // black pawn score
  PieceType.bKnight: -300, // black knight scrore
  PieceType.bBishop: -350, // black bishop score
  PieceType.bRook: -500, // black rook score
  PieceType.bQueen: -1000, // black queen score
  PieceType.bKing: -10000, // black king score
};

final pawnScore = [
  90,
  90,
  90,
  90,
  90,
  90,
  90,
  90,
  30,
  30,
  30,
  40,
  40,
  30,
  30,
  30,
  20,
  20,
  20,
  30,
  30,
  30,
  20,
  20,
  10,
  10,
  10,
  20,
  20,
  10,
  10,
  10,
  5,
  5,
  10,
  20,
  20,
  5,
  5,
  5,
  0,
  0,
  0,
  5,
  5,
  0,
  0,
  0,
  0,
  0,
  0,
  -10,
  -10,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
];

// knight positional score
final knightScore = [
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  0,
  0,
  10,
  10,
  0,
  0,
  -5,
  -5,
  5,
  20,
  20,
  20,
  20,
  5,
  -5,
  -5,
  10,
  20,
  30,
  30,
  20,
  10,
  -5,
  -5,
  10,
  20,
  30,
  30,
  20,
  10,
  -5,
  -5,
  5,
  20,
  10,
  10,
  20,
  5,
  -5,
  -5,
  0,
  0,
  0,
  0,
  0,
  0,
  -5,
  -5,
  -10,
  0,
  0,
  0,
  0,
  -10,
  -5
];

// bishop positional score
final bishopScore = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  10,
  10,
  0,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  10,
  0,
  0,
  0,
  0,
  10,
  0,
  0,
  30,
  0,
  0,
  0,
  0,
  30,
  0,
  0,
  0,
  -10,
  0,
  0,
  -10,
  0,
  0
];

// rook positional score
final rookScore = [
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  50,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  10,
  20,
  20,
  10,
  0,
  0,
  0,
  0,
  0,
  20,
  20,
  0,
  0,
  0
];

// king positional score
final kingScore = [
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  5,
  5,
  5,
  5,
  0,
  0,
  0,
  5,
  5,
  10,
  10,
  5,
  5,
  0,
  0,
  5,
  10,
  20,
  20,
  10,
  5,
  0,
  0,
  5,
  10,
  20,
  20,
  10,
  5,
  0,
  0,
  0,
  5,
  10,
  10,
  5,
  0,
  0,
  0,
  5,
  5,
  -5,
  -5,
  0,
  5,
  0,
  0,
  0,
  5,
  0,
  -15,
  0,
  10,
  0
];

// mirror positional score tables for opposite side
final mirrorScore = [
  Squares.a1,
  Squares.b1,
  Squares.c1,
  Squares.d1,
  Squares.e1,
  Squares.f1,
  Squares.g1,
  Squares.h1,
  Squares.a2,
  Squares.b2,
  Squares.c2,
  Squares.d2,
  Squares.e2,
  Squares.f2,
  Squares.g2,
  Squares.h2,
  Squares.a3,
  Squares.b3,
  Squares.c3,
  Squares.d3,
  Squares.e3,
  Squares.f3,
  Squares.g3,
  Squares.h3,
  Squares.a4,
  Squares.b4,
  Squares.c4,
  Squares.d4,
  Squares.e4,
  Squares.f4,
  Squares.g4,
  Squares.h4,
  Squares.a5,
  Squares.b5,
  Squares.c5,
  Squares.d5,
  Squares.e5,
  Squares.f5,
  Squares.g5,
  Squares.h5,
  Squares.a6,
  Squares.b6,
  Squares.c6,
  Squares.d6,
  Squares.e6,
  Squares.f6,
  Squares.g6,
  Squares.h6,
  Squares.a7,
  Squares.b7,
  Squares.c7,
  Squares.d7,
  Squares.e7,
  Squares.f7,
  Squares.g7,
  Squares.h7,
  Squares.a8,
  Squares.b8,
  Squares.c8,
  Squares.d8,
  Squares.e8,
  Squares.f8,
  Squares.g8,
  Squares.h8
];
