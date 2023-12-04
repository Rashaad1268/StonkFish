import "package:engine/engine.dart";

class UCIParser {
  static Move? parseMove(Board board, String moveStr) {
    /*
      Returns: Move or null
      null means that the move is an illegal move
    */
    final moves = board.generateLegalMoves();

    final int? from;
    final int? to;
    final String promotedPieceStr;

    try {
      from = squareFromAlgebraic(moveStr.substring(0, 2));
      to = squareFromAlgebraic(moveStr.substring(2, 4));
      promotedPieceStr = moveStr.substring(4);
    } catch (error) {
      return null;
    }

    for (final move in moves) {
      if (move.from == from && move.to == to) {
        final promotedPiece = move.promotedPiece;

        if (promotedPiece != null) {
          if (promotedPiece.isQueen && promotedPieceStr == "q") {
            return move;
          } else if (promotedPiece.isRook && promotedPieceStr == "r") {
            return move;
          } else if (promotedPiece.isBishop && promotedPieceStr == "b") {
            return move;
          } else if (promotedPiece.isKnight && promotedPieceStr == "n") {
            return move;
          }
        }

        return move;
      }
    }

    return null; // illegal move
  }

  static Board? parsePosition(String command) {
    Board? board;

    final movesStr = RegExp(r"moves\s.+").firstMatch(command)?[0];

    if (command.startsWith("startpos")) {
      board = Board.startingPosition;
    } else if (command.startsWith("fen")) {
      board = Board.fromFen(command.substring(4));
    }

    if (board != null && movesStr != null) {
      for (final moveStr in movesStr.substring(6).split(" ")) {
        final move = parseMove(board, moveStr);

        if (move != null) {
          board.makeMove(move);
        } else {
          throw ArgumentError("Invalid move $moveStr");
        }
      }
    }

    return board;
  }
}
