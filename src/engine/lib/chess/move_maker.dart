import 'package:engine/engine.dart';

extension MoveMaker on Board {
  void makeMove(Move move, {bool validateSide = true}) {
    assert((move.from < 64) && (move.from >= 0));
    assert((move.to < 64) && (move.to >= 0));

    if (validateSide) {
      if (turn != move.piece.side) {
        throw ArgumentError("You can't move the pieces of the other side");
      }
    }

    handleCastling(board: this, move: move);

    // Handle captures except en passant
    handleCaptures(board: this, move: move);

    var bitBoard = pieceBitBoards[move.piece]!;
    bitBoard = bitBoard.popBit(move.from);
    bitBoard = bitBoard.setBit(move.to);
    pieceBitBoards[move.piece] = bitBoard;

    handleEnPassant(board: this, move: move);
    handlePawnPromotion(board: this, move: move);

    if (validateSide) {
      halfMoveClock =
          (move.isCapture || move.piece.isPawn) ? 0 : halfMoveClock + 1;

      if (!move.piece.side.isWhite) {
        movesPlayed++;
      }
    }

    turn = turn.opposite();
  }
}

void handleCaptures({required Board board, required Move move}) {
  if (move.isCapture && !move.isEnPassant) {
    final pieceWhichWasCut = board.getPieceInSquare(move.to)!;
    board.pieceBitBoards[pieceWhichWasCut] =
        board.pieceBitBoards[pieceWhichWasCut]!.popBit(move.to);

    // Check if the square behind the piece which was captured is equal to Board.enPassant
    // if so, set Board.enPassant to null
    final oldEnPassant = (move.piece.side.isWhite) ? move.to - 8 : move.to + 8;
    if (oldEnPassant == board.enPassant) {
      board.enPassant = null;
    }

    // Update castling rights incase of rook capture
    if (pieceWhichWasCut.isRook) {
      if (pieceWhichWasCut.side == Side.white) {
        if ((move.to == Squares.h1) &&
            ((board.castlingRights & CastlingRights.wKingSide) > 0)) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.wKingSide;
        } else if (move.to == Squares.a1 &&
            ((board.castlingRights & CastlingRights.wQueenSide) > 0)) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.wQueenSide;
        }
      } else {
        if (move.to == Squares.h8 &&
            ((board.castlingRights & CastlingRights.bKingSide) > 0)) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.bKingSide;
        } else if (move.to == Squares.a8 &&
            ((board.castlingRights & CastlingRights.bQueenSide) > 0)) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.bQueenSide;
        }
      }
    }
  }
}

void handleCastling({required Board board, required Move move}) {
  // Handle castling
  if (move.isKingSideCastle || move.isQueenSideCastle) {
    final kingType =
        move.piece.side.isWhite ? PieceType.wKing : PieceType.bKing;
    final rookType =
        move.piece.side.isWhite ? PieceType.wRook : PieceType.bRook;
    var kingBitBoard = board.pieceBitBoards[kingType]!;

    kingBitBoard = kingBitBoard.setBit(move.to);
    kingBitBoard = kingBitBoard.popBit(move.from);
    board.pieceBitBoards[kingType] = kingBitBoard;

    var rookBitBoard = board.pieceBitBoards[rookType]!;
    if (move.piece.side.isWhite) {
      // Handle castling of the white side
      board.castlingRights = board.castlingRights ^
          (CastlingRights.wKingSide | CastlingRights.wQueenSide);

      if (move.isKingSideCastle) {
        rookBitBoard = rookBitBoard
            .setBit(Squares.f1)
            .popBit(Squares.h1); // White kingside
      } else {
        rookBitBoard = rookBitBoard
            .setBit(Squares.d1)
            .popBit(Squares.a1); // white queenside
      }
    } else {
      // Handle castling of the black side
      board.castlingRights = board.castlingRights ^
          (CastlingRights.bKingSide | CastlingRights.bQueenSide);

      if (move.isKingSideCastle) {
        rookBitBoard = rookBitBoard
            .setBit(Squares.f8)
            .popBit(Squares.h8); // black kingside
      } else {
        rookBitBoard = rookBitBoard
            .setBit(Squares.d8)
            .popBit(Squares.a8); // black queenside
      }
    }

    board.pieceBitBoards[rookType] = rookBitBoard;
  }

  // Update castling rights if king or rook is moved
  if (move.piece.isKing) {
    if (move.piece.side.isWhite) {
      if ((board.castlingRights & CastlingRights.wKingSide) != 0) {
        board.castlingRights = board.castlingRights ^ CastlingRights.wKingSide;
      }
      if ((board.castlingRights & CastlingRights.wQueenSide) != 0) {
        board.castlingRights = board.castlingRights ^ CastlingRights.wQueenSide;
      }
    } else {
      if ((board.castlingRights & CastlingRights.bKingSide) != 0) {
        board.castlingRights = board.castlingRights ^ CastlingRights.bKingSide;
      }
      if ((board.castlingRights & CastlingRights.bQueenSide) != 0) {
        board.castlingRights = board.castlingRights ^ CastlingRights.bQueenSide;
      }
    }
  } else if (move.piece.isRook) {
    if (move.piece.side.isWhite) {
      if (move.from == Squares.h1) {
        if ((board.castlingRights & CastlingRights.wKingSide) != 0) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.wKingSide;
        }
      } else if (move.from == Squares.a1) {
        if ((board.castlingRights & CastlingRights.wQueenSide) != 0) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.wQueenSide;
        }
      }
    } else {
      if (move.from == Squares.h8) {
        if ((board.castlingRights & CastlingRights.bKingSide) != 0) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.bKingSide;
        }
      } else if (move.from == Squares.a8) {
        if ((board.castlingRights & CastlingRights.bQueenSide) != 0) {
          board.castlingRights =
              board.castlingRights ^ CastlingRights.bQueenSide;
        }
      }
    }
  }
}

void handleEnPassant({required Board board, required Move move}) {
  board.halfMoveClock = 0;

  if (move.isDoublePush) {
    board.enPassant = (move.piece.side.isWhite) ? move.to + 8 : move.to - 8;
  }

  if (move.isEnPassant) {
    final captureSquare =
        (move.piece.side.isWhite) ? board.enPassant! + 8 : board.enPassant! - 8;
    final opponentPawnType =
        move.piece.side.isWhite ? PieceType.bPawn : PieceType.wPawn;

    board.pieceBitBoards[opponentPawnType] =
        board.pieceBitBoards[opponentPawnType]!.popBit(captureSquare);
  }
  if (!move.isDoublePush) board.enPassant = null; // Reset en passant square
}

void handlePawnPromotion({required Board board, required Move move}) {
  if (move.isPawnPromotion || move.isPawnPromotionCapture) {
    // Remove the pawn from the board
    board.pieceBitBoards[move.piece] =
        board.pieceBitBoards[move.piece]!.popBit(move.to);

    // Set the new piece
    board.pieceBitBoards[move.promotedPiece!] =
        board.pieceBitBoards[move.promotedPiece!]!.setBit(move.to);
  }

  // if (move.isPawnPromotionCapture) {
  //   final capturedPiece = board.getPieceInSquare(move.to);
  //   if (capturedPiece != null) {
  //     board.pieceBitBoards[capturedPiece] =
  //         board.pieceBitBoards[capturedPiece]!.popBit(move.to);
  //   }
  // }
}
