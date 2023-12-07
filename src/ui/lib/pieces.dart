import 'package:flutter/widgets.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:chessground/chessground.dart' as cg;

const cg.PieceAssets maestroPieceSet = IMapConst({
  cg.PieceKind.blackRook: AssetImage('lib/piece_images/bR.png'),
  cg.PieceKind.blackPawn: AssetImage('lib/piece_images/bP.png'),
  cg.PieceKind.blackKnight: AssetImage('lib/piece_images/bN.png'),
  cg.PieceKind.blackBishop: AssetImage('lib/piece_images/bB.png'),
  cg.PieceKind.blackQueen: AssetImage('lib/piece_images/bQ.png'),
  cg.PieceKind.blackKing: AssetImage('lib/piece_images/bK.png'),
  cg.PieceKind.whiteRook: AssetImage('lib/piece_images/wR.png'),
  cg.PieceKind.whiteKnight: AssetImage('lib/piece_images/wN.png'),
  cg.PieceKind.whiteBishop: AssetImage('lib/piece_images/wB.png'),
  cg.PieceKind.whiteQueen: AssetImage('lib/piece_images/wQ.png'),
  cg.PieceKind.whiteKing: AssetImage('lib/piece_images/wK.png'),
  cg.PieceKind.whitePawn: AssetImage('lib/piece_images/wP.png'),
});
