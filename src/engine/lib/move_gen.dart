import 'package:engine/engine.dart';

void generateMoves(Board board, {Side? side}) {
  /* 
    If `side` is specified, generate moves for that side.
    Else generate moves for the side with the current turn 
  */
  final moves = <Move>[];
  final _side = side ?? board.turn!;

  // for (var piece in (piece.side!.isWhite ? PieceType.whitePieces:PieceType.blackPieces)) {
  for (var piece in (_side.isWhite ? PieceType.whitePieces : PieceType.blackPieces)) {
    int sourceSquare;
    int targetSquare;

    // final piece = pieceType;
    var bitboard = BitBoard(board
        .pieceBitBoards[piece]!.value); // Create a new bitboard from the value

    if (piece.side.isWhite) {
      // gen white pawn moves and white castling moves here
      if (piece == PieceType.wPawn) {
        // loop over white pawns within white pawn bitboard
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init target square
          targetSquare = sourceSquare - 8;

          // generate quite pawn moves
          // if (!(targetSquare < Squares.a8) && !get_bit(occupancies[both], targetSquare))
          if (!(targetSquare < Squares.a8) &&
              board.allPieces.getBit(targetSquare) != 1) {
            // pawn promotion
            if (sourceSquare >= Squares.a7 && sourceSquare <= Squares.h7) {
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (q)");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (r)");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (b)");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (n)");
            } else {
              // one square ahead pawn move
              print(
                "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn push\n",
              );

              // two squares ahead pawn move
              // if ((sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) && !get_bit(occupancies[both], targetSquare - 8))
              if ((sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) &&
                  board.allPieces.getBit(targetSquare - 8) != 1) {
                print(
                    "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare - 8)} double pawn push\n");
              }
            }
          }

          // init pawn attacks bitboard
          var attacks = pawnAttacks[piece.side == Side.white ? 0 : 1]
                  [sourceSquare] &
              board.blackPieces;

          // generate pawn captures
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // pawn promotion
            if (sourceSquare >= Squares.a7 && sourceSquare <= Squares.h7) {
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (q) capture");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (r) capture");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (b) capture");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn promotion (n) capture");
            } else {
              // one square ahead pawn move
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn capture\n");
            }

            // pop ls1b of the pawn attacks
            attacks = attacks.popBit(targetSquare);
          }

          // generate enpassant captures
          if (board.enPassant != null) {
            // lookup pawn attacks and bitwise AND with enpassant square (bit)
            final enpassantAttacks =
                pawnAttacks[piece.side == Side.white ? 0 : 1][sourceSquare]
                        .value &
                    (1 << board.enPassant!);

            // make sure enpassant capture available
            if (enpassantAttacks != 0) {
              // init enpassant capture target square
              int targetEnpassant = getLs1bIndex(enpassantAttacks);
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetEnpassant)} pawn enpassant capture");
            }
          }

          // pop ls1b from piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      } else if (piece == PieceType.wKing) {
        /*
          This generates the moves based on the Board.castlingRights attribute
          it does not validate if the position of the king or if the king moved
        */
        // king side castling is available
        if ((board.castlingRights! & CastlingRights.wKingSide) != 0) {
          // make sure square between king and king's rook are empty
          // if (!get_bit(occupancies[both], f1) && !get_bit(occupancies[both], g1))
          if (board.allPieces.getBit(Squares.f1) != 1 &&
              board.allPieces.getBit(Squares.g1) != 1) {
            // make sure king and the f1 squares are not under attacks
            if (!board.isSquareAttacked(Squares.e1, Side.black) &&
                !board.isSquareAttacked(Squares.f1, Side.black)) {
              print("e1g1  castling move\n");
            }
          }
        }

        // queen side castling is available
        if ((board.castlingRights! & CastlingRights.wQueenSide) != 0) {
          // make sure square between king and queen's rook are empty
          // if (!get_bit(occupancies[both], d1) && !get_bit(occupancies[both], c1) && !get_bit(occupancies[both], b1))
          if (board.allPieces.getBit(Squares.d1) != 1 &&
              board.allPieces.getBit(Squares.c1) != 1 &&
              board.allPieces.getBit(Squares.b1) != 1) {
            // make sure king and the d1 squares are not under attacks
            if (!board.isSquareAttacked(Squares.e1, Side.black) &&
                !board.isSquareAttacked(Squares.d1, Side.black)) {
              print("e1c1  castling move\n");
            }
          }
        }
      }

      // loop over source squares of piece bitboard copy
    } else {
      // pick up black pawn bitboards index
      if (piece == PieceType.bPawn) {
        // loop over white pawns within white pawn bitboard
        while (bitboard.notEmpty()) {
          // init source square
          sourceSquare = getLs1bIndex(bitboard.value);

          // init target square
          targetSquare = sourceSquare + 8;

          // generate quite pawn moves
          // if (!(targetSquare > Squares.h1) && !get_bit(occupancies[both], targetSquare))
          if (!(targetSquare > Squares.h1) &&
              !board.allPieces.has(targetSquare)) {
            // pawn promotion
            if (sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) {
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} q pawn promotion\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} r pawn promotion\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} b pawn promotion\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} n pawn promotion\n");
            } else {
              // one square ahead pawn move
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn push\n");

              // two squares ahead pawn move
              if ((sourceSquare >= Squares.a7 && sourceSquare <= Squares.h7) &&
                  !board.allPieces.has(targetSquare + 8)) {
                print(
                    "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare + 8)} double pawn push\n");
              }
            }
          }

          // init pawn attacks bitboard
          var attacks = pawnAttacks[piece.side == Side.white ? 0 : 1]
                  [sourceSquare] &
              board.whitePieces;

          // generate pawn captures
          while (attacks.notEmpty()) {
            // init target square
            targetSquare = getLs1bIndex(attacks.value);

            // pawn promotion
            if (sourceSquare >= Squares.a2 && sourceSquare <= Squares.h2) {
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}q pawn promotion capture\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}r pawn promotion capture\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}b pawn promotion capture\n");
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}n pawn promotion capture\n");
            } else {
              // one square ahead pawn move
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} pawn capture\n");
            }

            // pop ls1b of the pawn attacks
            attacks = attacks.popBit(targetSquare);
          }

          // generate enpassant captures
          if (board.enPassant != null) {
            // lookup pawn attacks and bitwise AND with enpassant square (bit)
            final enpassantAttacks =
                pawnAttacks[piece.side == Side.white ? 0 : 1][sourceSquare] &
                    BitBoard(1 << board.enPassant!);

            // make sure enpassant capture available
            if (enpassantAttacks.notEmpty()) {
              // init enpassant capture target square
              int targetEnpassant = getLs1bIndex(enpassantAttacks.value);
              print(
                  "${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetEnpassant)} pawn enpassant capture\n");
            }
          }

          // pop ls1b from piece bitboard copy
          bitboard = bitboard.popBit(sourceSquare);
        }
      }

      // castling moves
      if (piece == PieceType.bKing) {
        // king side castling is available
        if ((board.castlingRights! & CastlingRights.bKingSide) != 0) {
          // make sure square between king and king's rook are empty
          // if (!get_bit(occupancies[both], f8) && !get_bit(occupancies[both], g8))
          if (!board.allPieces.has(Squares.f8) &&
              !board.allPieces.has(Squares.g8)) {
            // make sure king and the f8 squares are not under attacks
            if (!board.isSquareAttacked(Squares.e8, Side.white) &&
                !board.isSquareAttacked(Squares.f8, Side.white)) {
              print("e8g8  castling move\n");
            }
          }
        }

        // queen side castling is available
        if ((board.castlingRights! & CastlingRights.bQueenSide) != 0) {
          // make sure square between king and queen's rook are empty
          // if (!get_bit(occupancies[both], d8) && !get_bit(occupancies[both], c8) && !get_bit(occupancies[both], b8))
          if (!board.allPieces.has(Squares.d8) &&
              !board.allPieces.has(Squares.c8) &&
              !board.allPieces.has(Squares.b8)) {
            // make sure king and the d8 squares are not under attacks
            if (!board.isSquareAttacked(Squares.e8, Side.white) &&
                !board.isSquareAttacked(Squares.d8, Side.white)) {
              print("e8c8  castling move: \n");
            }
          }
        }
      }
    }

    // gen moves of rest of the pieces
    if (piece.isKnight) {
      // loop over source squares of piece bitboard copy
      while (bitboard.notEmpty()) {
        // init source square
        sourceSquare = getLs1bIndex(bitboard.value);

        // init piece attacks in order to get set of target squares
        var attacks = knightAttacks[sourceSquare] & ~board.piecesOf(piece.side);

        // loop over target squares available from generated attacks
        while (attacks.notEmpty()) {
          // init target square
          targetSquare = getLs1bIndex(attacks.value);

          // quite move
          // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
          if (!board.piecesOf(piece.side.opposite()).has(targetSquare)) {
            print(
                "(N) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} Piece quiet move\n");
          } else {
            // capture move
            print(
                "(N) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece capture\n");
          }

          // pop ls1b in current attacks set
          attacks = attacks.popBit(targetSquare);
        }

        // pop ls1b of the current piece bitboard copy
        bitboard = bitboard.popBit(sourceSquare);
      }
    } else if (piece.isBishop) {
      // loop over source squares of piece bitboard copy
      while (bitboard.notEmpty()) {
        // init source square
        sourceSquare = getLs1bIndex(bitboard.value);

        // init piece attacks in order to get set of target squares
        var attacks = getBishopAttacks(sourceSquare, board.allPieces) &
            ~board.piecesOf(piece.side);

        // loop over target squares available from generated attacks
        while (attacks.notEmpty()) {
          // init target square
          targetSquare = getLs1bIndex(attacks.value);

          // quite move
          // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
          if (!board.piecesOf(piece.side.opposite()).has(targetSquare)) {
            print(
              "(B) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece quiet move\n",
            );
          } else {
            // capture move
            print(
              "(B) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)}  piece capture\n",
            );
          }

          // pop ls1b in current attacks set
          attacks = attacks.popBit(targetSquare);
        }

        // pop ls1b of the current piece bitboard copy
        bitboard = bitboard.popBit(sourceSquare);
      }
    } else if (piece.isRook) {
      // loop over source squares of piece bitboard copy
      while (bitboard.notEmpty()) {
        // init source square
        sourceSquare = getLs1bIndex(bitboard.value);

        // init piece attacks in order to get set of target squares
        var attacks = getRookAttacks(sourceSquare, board.allPieces) &
            ~board.piecesOf(piece.side);

        // loop over target squares available from generated attacks
        while (attacks.notEmpty()) {
          // init target square
          targetSquare = getLs1bIndex(attacks.value);

          // quite move
          // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
          if (!board.piecesOf(piece.side.opposite()).has(targetSquare)) {
            print(
                "(R) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
          } else {
            // capture move
            print(
                "(R) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
          }

          // pop ls1b in current attacks set
          attacks = attacks.popBit(targetSquare);
        }

        // pop ls1b of the current piece bitboard copy
        bitboard = bitboard.popBit(sourceSquare);
      }
    } else if (piece.isQueen) {
      // loop over source squares of piece bitboard copy
      while (bitboard.notEmpty()) {
        // init source square
        sourceSquare = getLs1bIndex(bitboard.value);

        // init piece attacks in order to get set of target squares
        var attacks = getQueenAttacks(sourceSquare, board.allPieces) &
            ~board.piecesOf(piece.side);

        // loop over target squares available from generated attacks
        while (attacks.notEmpty()) {
          // init target square
          targetSquare = getLs1bIndex(attacks.value);

          // quite move
          // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
          if (!board.piecesOf(piece.side.opposite()).has(targetSquare)) {
            print(
                "(Q) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
          } else {
            // capture move
            print(
                "(Q) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
          }

          // pop ls1b in current attacks set
          attacks = attacks.popBit(targetSquare);
        }

        // pop ls1b of the current piece bitboard copy
        bitboard = bitboard.popBit(sourceSquare);
      }
    } else if (piece.isKing) {
      // loop over source squares of piece bitboard copy
      while (bitboard.notEmpty()) {
        // init source square
        sourceSquare = getLs1bIndex(bitboard.value);

        // init piece attacks in order to get set of target squares
        var attacks = kingAttacks[sourceSquare] & ~board.piecesOf(piece.side);

        // loop over target squares available from generated attacks
        while (attacks.notEmpty()) {
          // init target square
          targetSquare = getLs1bIndex(attacks.value);

          // quite move
          // if (!get_bit(((side == white) ? occupancies[black] : occupancies[white]), targetSquare))
          if (!board.piecesOf(piece.side.opposite()).has(targetSquare)) {
            print(
                "(K) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece quiet move\n");
          } else {
            // capture move
            print(
                "(K) ${squareToAlgebraic(sourceSquare)} ${squareToAlgebraic(targetSquare)} piece capture\n");
          }

          // pop ls1b in current attacks set
          attacks = attacks.popBit(targetSquare);
        }

        // pop ls1b of the current piece bitboard copy
        bitboard = bitboard.popBit(sourceSquare);
      }
    }
  }
}
