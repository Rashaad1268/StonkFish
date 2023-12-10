import 'package:engine/engine.dart';

extension Eval on Board {
  static int nodes = 0;
  static int ply = 0;
  static Move? bestMove;

  int evaluate() {
    var score = 0;

    for (final entry in pieceBitBoards.entries) {
      final piece = entry.key;
      var bitboard = entry.value;

      while (bitboard.notEmpty) {
        final square = getLs1bIndex(bitboard.value);

        score += materialScore[piece]!;

        switch (piece) {
          // evaluate white pieces
          case PieceType.wPawn:
            score += pawnScore[square];
            break;
          case PieceType.wKnight:
            score += knightScore[square];
            break;
          case PieceType.wBishop:
            score += bishopScore[square];
            break;
          case PieceType.wRook:
            score += rookScore[square];
            break;
          case PieceType.wKing:
            score += kingScore[square];
            break;

          // evaluate black pieces
          case PieceType.bPawn:
            score -= pawnScore[mirrorScore[square]];
            break;
          case PieceType.bKnight:
            score -= knightScore[mirrorScore[square]];
            break;
          case PieceType.bBishop:
            score -= bishopScore[mirrorScore[square]];
            break;
          case PieceType.bRook:
            score -= rookScore[mirrorScore[square]];
            break;
          case PieceType.bKing:
            score -= kingScore[mirrorScore[square]];
            break;

          default:
            break;
        }

        // pop ls1b
        bitboard = bitboard.popBit(square);
      }
    }

    return turn.isWhite ? score : -score;
  }

  int negamax({required int alpha, required int beta, required int depth}) {
    // recursion escape condition
    if (depth == 0) {
      // return evaluation
      return evaluate();
    }

    // increment nodes count
    nodes++;

    // best move so far
    Move? bestSoFar;

    // old value of alpha
    int oldAlpha = alpha;

    // loop over moves within a movelist
    for (final move in generateLegalMoves()) {
      // preserve board state
      final boardCopy = toCopy();

      // increment ply
      ply++;

      // score current move
      int score = -negamax(alpha: -beta, beta: -alpha, depth: depth - 1);

      // decrement ply
      ply--;

      // take move back
      revertTo(boardCopy);

      // fail-hard beta cutoff
      if (score >= beta) {
        // node (move) fails high
        return beta;
      }

      // found a better move
      if (score > alpha) {
        // PV node (move)
        alpha = score;

        // if root move
        if (ply == 0) {
          // associate best move with the best score
          bestSoFar = move;
        }
      }
    }

    // found better move
    if (oldAlpha != alpha) {
      // init best move
      bestMove = bestSoFar;
    } else {
      bestMove = null;
    }

    // node (move) fails low
    return alpha;
  }

  void searchPosition(int depth) {
    // find best move within a given position
    int score = negamax(alpha: -50000, beta: 50000, depth: depth);

    // best move placeholder
    print("bestmove $bestMove");
    print(bestMove.toString());
    print("\n");
  }
}
