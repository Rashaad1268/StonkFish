import 'package:engine/engine.dart';
import 'package:chessground/chessground.dart' as cg;

PieceType? getPromotedPiece({cg.Role? role, required Side side}) {
  if (role == null) return null;

  switch (role) {
    case cg.Role.queen:
      return side.isWhite ? PieceType.wQueen : PieceType.bQueen;

    case cg.Role.rook:
      return side.isWhite ? PieceType.wRook : PieceType.bRook;

    case cg.Role.bishop:
      return side.isWhite ? PieceType.wBishop : PieceType.bBishop;

    case cg.Role.knight:
      return side.isWhite ? PieceType.wKnight : PieceType.bKnight;

    default:
      throw ArgumentError("Invalid promotion piece");
  }
}
