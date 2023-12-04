import 'package:engine/engine.dart';

// ignore_for_file: constant_identifier_names

const kFileNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
const kRankNames = ['1', '2', '3', '4', '5', '6', '7', '8'];

const squareToCoord = [
  "a8",
  "b8",
  "c8",
  "d8",
  "e8",
  "f8",
  "g8",
  "h8",
  "a7",
  "b7",
  "c7",
  "d7",
  "e7",
  "f7",
  "g7",
  "h7",
  "a6",
  "b6",
  "c6",
  "d6",
  "e6",
  "f6",
  "g6",
  "h6",
  "a5",
  "b5",
  "c5",
  "d5",
  "e5",
  "f5",
  "g5",
  "h5",
  "a4",
  "b4",
  "c4",
  "d4",
  "e4",
  "f4",
  "g4",
  "h4",
  "a3",
  "b3",
  "c3",
  "d3",
  "e3",
  "f3",
  "g3",
  "h3",
  "a2",
  "b2",
  "c2",
  "d2",
  "e2",
  "f2",
  "g2",
  "h2",
  "a1",
  "b1",
  "c1",
  "d1",
  "e1",
  "f1",
  "g1",
  "h1",
];

const startPosFEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

const trickyPosition =
    "r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1";

enum Side {
  white,
  black;

  bool get isWhite => this == white;

  Side opposite() => this == white ? black : white;
}

abstract class Squares {
  static const a8 = 0;
  static const b8 = 1;
  static const c8 = 2;
  static const d8 = 3;
  static const e8 = 4;
  static const f8 = 5;
  static const g8 = 6;
  static const h8 = 7;
  static const a7 = 8;
  static const b7 = 9;
  static const c7 = 10;
  static const d7 = 11;
  static const e7 = 12;
  static const f7 = 13;
  static const g7 = 14;
  static const h7 = 15;
  static const a6 = 16;
  static const b6 = 17;
  static const c6 = 18;
  static const d6 = 19;
  static const e6 = 20;
  static const f6 = 21;
  static const g6 = 22;
  static const h6 = 23;
  static const a5 = 24;
  static const b5 = 25;
  static const c5 = 26;
  static const d5 = 27;
  static const e5 = 28;
  static const f5 = 29;
  static const g5 = 30;
  static const h5 = 31;
  static const a4 = 32;
  static const b4 = 33;
  static const c4 = 34;
  static const d4 = 35;
  static const e4 = 36;
  static const f4 = 37;
  static const g4 = 38;
  static const h4 = 39;
  static const a3 = 40;
  static const b3 = 41;
  static const c3 = 42;
  static const d3 = 43;
  static const e3 = 44;
  static const f3 = 45;
  static const g3 = 46;
  static const h3 = 47;
  static const a2 = 48;
  static const b2 = 49;
  static const c2 = 50;
  static const d2 = 51;
  static const e2 = 52;
  static const f2 = 53;
  static const g2 = 54;
  static const h2 = 55;
  static const a1 = 56;
  static const b1 = 57;
  static const c1 = 58;
  static const d1 = 59;
  static const e1 = 60;
  static const f1 = 61;
  static const g1 = 62;
  static const h1 = 63;
}

// Trust me, the values below are not random
// Represents a board with all bits set to 1 except the bits in the A file
const NOT_A_FILE = BitBoard(0xFEFEFEFEFEFEFEFE);

// A board with all bits set to 1 except the bits in the A file and the B file
const NOT_AB_FILE = BitBoard(0xFCFCFCFCFCFCFCFC);

// Board with all bits set to 1 except the bits in the H file
const NOT_H_FILE = BitBoard(0x7F7F7F7F7F7F7F7F);

// A board with all bits set to 1 except the bits in the H file and the G file
const NOT_HG_FILE = BitBoard(0x3F3F3F3F3F3F3F3F);

const bishopRelevantBits = [
  6,
  5,
  5,
  5,
  5,
  5,
  5,
  6,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  7,
  7,
  7,
  7,
  5,
  5,
  5,
  5,
  7,
  9,
  9,
  7,
  5,
  5,
  5,
  5,
  7,
  9,
  9,
  7,
  5,
  5,
  5,
  5,
  7,
  7,
  7,
  7,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  5,
  6,
  5,
  5,
  5,
  5,
  5,
  5,
  6
];

const rookRelevantBits = [
  12,
  11,
  11,
  11,
  11,
  11,
  11,
  12,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  11,
  10,
  10,
  10,
  10,
  10,
  10,
  11,
  12,
  11,
  11,
  11,
  11,
  11,
  11,
  12
];
