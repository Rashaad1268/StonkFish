import 'dart:collection';

import 'package:engine/engine.dart';

class BoardCopy {
  final HashMap<PieceType, BitBoard> pieceBitBoards;
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
        pieceBitBoards: HashMap.from({...pieceBitBoards}),
        turn: turn,
        castlingRights: castlingRights,
        enPassant: enPassant,
        numOfMovesPlayed: movesPlayed.length);
  }

  void revertTo(BoardCopy copy) {
    pieceBitBoards.addAll(copy.pieceBitBoards);
    turn = copy.turn;
    castlingRights = copy.castlingRights;
    enPassant = copy.enPassant;

    // Remove all of the moves played after taking the copy
    movesPlayed.removeRange(copy.numOfMovesPlayed, movesPlayed.length);
  }
}
