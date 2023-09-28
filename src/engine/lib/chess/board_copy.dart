import 'package:engine/engine.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class BoardCopy {
  final IMap<PieceType, BitBoard> pieceBitBoards;
  final Side turn;
  final int castlingRights;
  final int? enPassant;
  final int numOfMovesPlayed;

  const BoardCopy(
      {required this.pieceBitBoards,
      required this.turn,
      required this.castlingRights,
      required this.enPassant,
      required this.numOfMovesPlayed});
}

extension BoardState on Board {
  BoardCopy toCopy() {
    return BoardCopy(
        pieceBitBoards: pieceBitBoards.lock,
        turn: turn,
        castlingRights: castlingRights,
        enPassant: enPassant,
        numOfMovesPlayed: movesPlayed.length);
  }

  void revertTo(BoardCopy copy) {
    pieceBitBoards.addAll(copy.pieceBitBoards.unlock);
    turn = copy.turn;
    castlingRights = copy.castlingRights;
    enPassant = copy.enPassant;

    // Remove all of the moves played after taking the copy
    movesPlayed.removeRange(copy.numOfMovesPlayed, movesPlayed.length);
  }
}
